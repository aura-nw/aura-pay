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
        if (message.containsKey('price') && message.containsKey('balances')) {
          add(
            HomePageEventOnUpdateCurrency(
              balances: message['balances'],
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

          final Dio horoScopeDio = dioFactory(message['horoscope_url']);

          final Dio auraNetworkDio = dioFactory(message['aura_network_url']);

          final BalanceUseCase horoScropeBalanceUseCase = balanceUseCaseFactory(horoScopeDio);

          final balances = await horoScropeBalanceUseCase.getBalances(
            address: message['address'],
            environment: message['environment'],
          );

          final BalanceUseCase auraNetworkBalanceUseCase = balanceUseCaseFactory(auraNetworkDio);

          final price = await auraNetworkBalanceUseCase.getTokenPrice();

          // Send the API response back to the main isolate
          sendPort.send({
            'price': price,
            'balances': balances,
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
      balances: [],
    ));
    final account = await _accountUseCase.getFirstAccount();

    _isolateSendPort.send({
      'horoscope_url': config.horoScopeUrl + config.horoScopeVersion,
      'aura_network_url': config.auraNetworkBaseUrl + config.auraNetworkVersion,
      'address': account?.address,
      'environment': config.environment.environmentString,
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
        balances: event.balances,
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
