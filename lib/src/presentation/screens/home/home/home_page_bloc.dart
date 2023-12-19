import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/factory_creator/factory_creator.dart';
import 'home_page_event.dart';
import 'home_page_state.dart';

final class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final AuraAccountUseCase _accountUseCase;

  late Isolate _isolate;
  late ReceivePort _receivePort;
  late SendPort _isolateSendPort;

  HomePageBloc(this._accountUseCase)
      : super(
          const HomePageState(),
        ) {
    _initIsolate();
    on(_onFetchPrice);
    on(_onUpdateCurrency);
  }

  void _initIsolate() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(_apiIsolate, _receivePort.sendPort);

    // Listen to the stream only once
    _receivePort.listen((message) {
      if (message is SendPort) {
        _isolateSendPort = message;
      }
      if (message is Map<String, dynamic>) {
        if (message.containsKey('price') && message.containsKey('balance')) {
          add(
            HomePageEventOnUpdateCurrency(
              balance: message['balance'],
              price: message['price'],
            ),
          );
        }
      }
    });

    add(
      const HomePageEventOnFetchTokenPrice(),
    );
  }

  final config = getIt.get<PyxisMobileConfig>();

  static void _apiIsolate(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        try {
          final SmartAccountUseCase smartAccountUseCase =
              smartAccountUseCaseFactory(
            message['auraSmartAccountEnvironment'],
          );

          final Dio dio = dioFactory(message['base_url']);

          final TokenUseCase tokenUseCase = tokenUseCaseFactory(dio);

          final balance = await smartAccountUseCase.getToken(
            address: message['address'],
          );

          final price = await tokenUseCase.getTokenPrice(
            id: message['aura_id'],
            currency: 'usd',
          );

          // Send the API response back to the main isolate
          sendPort.send({
            'price': price,
            'balance': balance,
          });
        } catch (error) {
          // Send the error back to the main isolate
          sendPort.send({'error': error.toString()});
        }
      }
    }
  }

  void _onFetchPrice(
    HomePageEventOnFetchTokenPrice event,
    Emitter<HomePageState> emit,
  ) async {
    emit(state.copyWith(
      balance: '0',
    ));
    final account = await _accountUseCase.getFirstAccount();

    _isolateSendPort.send({
      'base_url': config.coinGeckoUrl + config.coinGeckoVersion,
      'address': account?.address,
      'aura_id': config.auraId,
      'auraSmartAccountEnvironment': config.environment.toSME,
    });
  }

  void _onUpdateCurrency(
    HomePageEventOnUpdateCurrency event,
    Emitter<HomePageState> emit,
  ) {
    emit(
      state.copyWith(
        price: event.price,
        balance: event.balance,
      ),
    );
  }

  @override
  Future<void> close() {
    _receivePort.close();
    _isolate.kill();
    return super.close();
  }
}
