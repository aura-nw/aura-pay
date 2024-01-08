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
  SendPort? _isolateSendPort;

  HomePageBloc(this._accountUseCase)
      : super(
          const HomePageState(),
        ) {
    _initIsolate();
    on(_onFetchPrice);
    on(_onFetchPriceWithAddress);
    on(_onUpdateBalance);
    on(_onUpdatePrice);
    on(_onHideTokenValue);
  }

  void _initIsolate() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(_apiIsolate, _receivePort.sendPort);

    // Listen to the stream only once
    _receivePort.listen((message) {
      if (message is SendPort) {
        // receive isolateSendPort from other thread
        if (_isolateSendPort == null) {
          // only call that first run.
          add(
            const HomePageEventOnFetchTokenPrice(),
          );
          _isolateSendPort = message;
        } else {
          _isolateSendPort = message;
        }
      }
      if (message is Map<String, dynamic>) {
        if (message.containsKey('balances')) {
          add(
            HomePageEventOnUpdateBalances(
              balances: message['balances'],
            ),
          );
        } else if (message.containsKey('price')) {
          add(
            HomePageEventOnUpdatePrice(
              price: message['price'],
            ),
          );
        } else {
          LogProvider.log('${message['error']}');
        }
      }
    });
  }

  final config = getIt.get<PyxisMobileConfig>();

  static void _apiIsolate(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        try {
          final Dio horoScopeDio = dioFactory(message['horoscope_url']);

          final Dio auraNetworkDio = dioFactory(message['aura_network_url']);

          final BalanceUseCase horoScropeBalanceUseCase =
              balanceUseCaseFactory(horoScopeDio);

          final TokenUseCase auraNetworkTokenUseCase =
          tokenUseCaseFactory(auraNetworkDio);

          await _getBalances(horoScropeBalanceUseCase, message, sendPort);

          await _getPrice(auraNetworkTokenUseCase, message, sendPort);
        } catch (error) {
          // Send the error back to the main isolate
          sendPort.send({'error': error.toString()});
        }
      }
    }
  }

  static Future<void> _getBalances(BalanceUseCase horoScropeBalanceUseCase,
      Map<String, dynamic> message, SendPort sendPort) async {
    try {
      final balances = await horoScropeBalanceUseCase.getBalances(
        address: message['address'],
        environment: message['environment'],
      );

      // Send the API response back to the main isolate
      sendPort.send({
        'balances': balances,
      });
    } catch (e) {
      // Send the error back to the main isolate
      sendPort.send({'error': e.toString()});
    }
  }

  static Future<void> _getPrice(TokenUseCase tokenUseCase,
      Map<String, dynamic> message, SendPort sendPort) async {
    try {
      final price = await tokenUseCase.getAuraTokenPrice();

      // Send the API response back to the main isolate
      sendPort.send({
        'price': price,
      });
    } catch (e) {
      // Send the error back to the main isolate
      sendPort.send({'error': e.toString()});
    }
  }

  void _onFetchPrice(
    HomePageEventOnFetchTokenPrice event,
    Emitter<HomePageState> emit,
  ) async {
    final account = await _accountUseCase.getFirstAccount();

    print('run');
    _isolateSendPort?.send(
      _createMsg(
        account?.address,
      ),
    );
  }

  void _onFetchPriceWithAddress(
    HomePageEventOnFetchTokenPriceWithAddress event,
    Emitter<HomePageState> emit,
  ) async {
    _isolateSendPort?.send(
      _createMsg(
        event.address,
      ),
    );
  }

  Map<String, dynamic> _createMsg(String? address) {
    return {
      'horoscope_url': config.horoScopeUrl + config.horoScopeVersion,
      'aura_network_url': config.auraNetworkBaseUrl + config.auraNetworkVersion,
      'address': address,
      'environment': config.environment.environmentString,
      'auraSmartAccountEnvironment': config.environment.toSME,
    };
  }

  void _onUpdateBalance(
    HomePageEventOnUpdateBalances event,
    Emitter<HomePageState> emit,
  ) {
    emit(
      state.copyWith(
        balances: event.balances,
      ),
    );
  }

  void _onUpdatePrice(
    HomePageEventOnUpdatePrice event,
    Emitter<HomePageState> emit,
  ) {
    emit(
      state.copyWith(
        price: event.price,
      ),
    );
  }

  void _onHideTokenValue(
    HomePageEventOnHideTokenValue event,
    Emitter<HomePageState> emit,
  ) {
    emit(
      state.copyWith(
        hideTokenValue: !state.hideTokenValue,
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
