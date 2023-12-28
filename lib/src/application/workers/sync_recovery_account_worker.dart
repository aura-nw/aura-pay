import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

import 'dart:developer' as dev;

import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/factory_creator/factory_creator.dart';

class SyncRecoveryAccountWorker {
  SyncRecoveryAccountWorker();

  void start() {
    _initIsolate();
  }

  late Isolate _isolate;
  late ReceivePort _receivePort;
  SendPort? _isolateSendPort;

  void _initIsolate() async {
    final config = getIt.get<PyxisMobileConfig>();
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(_apiIsolate, _receivePort.sendPort);

    // Listen to the stream only once
    _receivePort.listen((message) {
      if (message is SendPort) {
        // receive isolateSendPort from other thread
        if (_isolateSendPort == null) {
          // only call that first run.
          _isolateSendPort = message;
        } else {
          _isolateSendPort = message;
        }

        _isolateSendPort?.send(
          {
            'base_url': config.pyxisBaseUrl + config.pyxisBaseUrl,
            'auraSmartAccountEnvironment': config.environment.toSME,
          },
        );
      } else if (message == true) {
        dev.log('done task. Starting kill isolate');
        _close();
      } else {
        dev.log('Receive Error from isolate: ${message.toString()}');
      }
    });
  }

  static void _apiIsolate(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        try {
          final Dio dio = dioFactory(
            message['base_url'],
          );
          final Isar isar = await getIsar();

          final SmartAccountUseCase smartAccountUseCase =
              smartAccountUseCaseFactory(
            message['auraSmartAccountEnvironment'],
            dio,
            isar,
          );
          await _syncRecoveryAccount(smartAccountUseCase);

          sendPort.send(true);
        } catch (error) {
          // Send the error back to the main isolate
          sendPort.send({'error': error.toString()});
        }
      }
    }
  }

  static Future<void> _syncRecoveryAccount(
    SmartAccountUseCase smartAccountUseCase,
  ) async {
    try {
      final recoveryAccounts =
          await smartAccountUseCase.getLocalRecoveryAccounts();

      if (recoveryAccounts.isEmpty) return;

      for (final recovery in recoveryAccounts) {
        await smartAccountUseCase.insertRecoveryAccount(
          name: recovery.name,
          smartAccountAddress: recovery.smartAccountAddress,
          recoveryAddress: recovery.recoveryAddress,
        );

        await smartAccountUseCase.deleteRecoveryAccount(
          id: recovery.id,
        );
      }

      dev.log('_syncRecoveryAccount success');
    } catch (e) {
      dev.log('_syncRecoveryAccount started error ${e.toString()}');
    }
  }

  void _close() {
    _receivePort.close();
    _isolate.kill();
  }
}
