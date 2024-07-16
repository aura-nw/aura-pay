import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/core/constants/network.dart';
import 'package:pyxis_v2/src/core/factory_creator/account_balance.dart';
import 'package:pyxis_v2/src/core/factory_creator/dio.dart';
import 'package:pyxis_v2/src/core/factory_creator/isar.dart';
import 'package:pyxis_v2/src/core/factory_creator/token_market.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

final class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final TokenMarketUseCase _tokenMarketUseCase;
  final BalanceUseCase _balanceUseCase;
  final AccountUseCase _accountUseCase;
  final PyxisMobileConfig config;

  HomePageBloc(
    this._accountUseCase,
    this._tokenMarketUseCase,
    this._balanceUseCase, {
    required this.config,
  }) : super(
          const HomePageState(),
        ) {
    _initMultiThread();
    on(_loadStorageData);
    on(_onUpdateTokenMarket);
    on(_onUpdateAccountBalance);
  }

  late Isolate _balanceIsolate;
  SendPort? _balanceSendPort;

  late Isolate _tokenIsolate;
  SendPort? _tokenSendPort;

  // late Isolate _nftIsolate;
  SendPort? _nftSendPort;

  late ReceivePort _mainTokenReceivePort;
  late ReceivePort _mainBalanceReceivePort;

  void _initMultiThread() async {
    _mainTokenReceivePort = ReceivePort();
    _mainBalanceReceivePort = ReceivePort();

    _tokenIsolate = await Isolate.spawn(
        _backgroundFetchTokenMarket, _mainTokenReceivePort.sendPort);

    _balanceIsolate = await Isolate.spawn(
        _backgroundFetchBalance, _mainBalanceReceivePort.sendPort);

    // Listen to the stream only once
    _mainTokenReceivePort.listen(
      (message) {
        if (message is Map<String, dynamic>) {
          if (message.containsKey('token_market_port')) {
            // receive isolateSendPort from token thread
            _tokenSendPort = message['token_market_port'] as SendPort;

            // Only first run
            _sendMessageFetchTokenMarket();
          } else if (message.containsKey('token_market')) {
            add(
              HomePageOnUpdateTokenMarketEvent(
                tokenMarkets: message['token_market'],
              ),
            );
          } else {
            LogProvider.log('fetch market token error ${message['error']}');
          }
        }
      },
    );

    // Listen to the stream only once
    _mainBalanceReceivePort.listen(
      (message) {
        if (message is Map<String, dynamic>) {
          if (message.containsKey('balance_port')) {
            _balanceSendPort = message['balance_port'] as SendPort;

            add(
              const HomePageOnGetStorageDataEvent(),
            );
          } else if (message.containsKey('balanceMap')) {
            add(
              HomePageOnUpdateAccountBalanceEvent(
                balanceMap: message['balanceMap'],
              ),
            );
          } else {
            LogProvider.log('fetch balance error ${message['error']}');
          }
        }
      },
    );
  }

  static void _backgroundFetchTokenMarket(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();

    sendPort.send({
      'token_market_port': receivePort.sendPort,
    });

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        try {
          final String urlV1 = message['base_url_v1'];
          final Dio dio = dioFactory(urlV1);

          final Isar isar = await getIsar();

          final TokenMarketUseCase tokenMarketUseCase = tokenMarketFactory(
            dio,
            isar,
          );

          _fetchTokenMarket(
            tokenMarketUseCase,
            sendPort,
          );
        } catch (error) {
          // Send the error back to the main isolate
          sendPort.send({'error': error.toString()});
        }
      }
    }
  }

  static void _backgroundFetchBalance(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();

    sendPort.send({
      'balance_port': receivePort.sendPort,
    });

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        try {
          final Isar isar = await getIsar();

          final BalanceUseCase balanceUseCase = balanceFactory(isar);

          await _fetchBalance(
            balanceUseCase,
            sendPort,
            message,
          );
        } catch (error) {
          // Send the error back to the main isolate
          sendPort.send({'error': error.toString()});
        }
      }
    }
  }

  static Future<void> _fetchTokenMarket(
    TokenMarketUseCase tokenMarketUseCase,
    SendPort sendPort,
  ) async {
    try {
      final tokenMarkets = await tokenMarketUseCase.getRemoteTokenMarket();

      sendPort.send({
        'token_market': tokenMarkets,
      });

      await tokenMarketUseCase.putAll(
        request: tokenMarkets
            .map(
              (e) => PutAllTokenMarketRequest(
                id: e.id,
                coinId: e.coinId,
                symbol: e.symbol,
                name: e.name,
                image: e.image,
                currentPrice: e.currentPrice,
                priceChangePercentage24h: e.priceChangePercentage24h,
                denom: e.denom,
                decimal: e.decimal,
              ),
            )
            .toList(),
      );
    } catch (e) {
      // Send the error back to the main isolate
      sendPort.send({'error': e.toString()});
    }
  }

  static Future<void> _fetchBalance(
    BalanceUseCase balanceUseCase,
    SendPort sendPort,
    Map<String, dynamic> message,
  ) async {
    try {
      final List<AppNetwork> networks = message['networks'];

      final Account account = message['account'];

      Map<AppNetworkType, String> result = {};

      for (final network in networks) {
        final type = network.type;

        if (type == AppNetworkType.evm) {
          String amount = await balanceUseCase.getEvmBalanceByAddress(
            address: account.evmAddress,
          );

          result[type] = amount;
        } else if (type == AppNetworkType.cosmos) {
          String amount = await balanceUseCase.getCosmosBalanceByAddress(
            address: account.cosmosAddress ?? '',
          );

          result[type] = amount;
        }
      }

      sendPort.send({
        'balanceMap': result,
      });
    } catch (e) {
      // Send the error back to the main isolate
      sendPort.send({'error': e.toString()});
    }
  }

  void _loadStorageData(
    HomePageOnGetStorageDataEvent event,
    Emitter<HomePageState> emit,
  ) async {
    try {
      final List<AppNetwork> networks = createNetwork(config);

      emit(
        state.copyWith(
          networks: networks,
        ),
      );

      final accounts = await _accountUseCase.getAll();

      final activeAccount = accounts.firstWhereOrNull(
        (a) => a.index == 0,
      );

      emit(
        state.copyWith(
          activeAccount: activeAccount,
          accounts: accounts,
        ),
      );

      _sendMessageFetchAccountBalance(
        networks: networks,
      );

      final tokenMarkets = await _tokenMarketUseCase.getAll();

      final accountBalance = await _balanceUseCase.getByAccountID(
        accountId: activeAccount!.id,
      );

      emit(
        state.copyWith(
          tokenMarkets: tokenMarkets,
          accountBalance: accountBalance,
          auraMarket: tokenMarkets.firstWhereOrNull(
            (token) => token.symbol == config.config.evmInfo.symbol,
          ),
        ),
      );
    } catch (e) {
      LogProvider.log(e.toString());
    }
  }

  void _onUpdateTokenMarket(
    HomePageOnUpdateTokenMarketEvent event,
    Emitter<HomePageState> emit,
  ) {
    emit(
      state.copyWith(
        tokenMarkets: event.tokenMarkets,
        auraMarket: event.tokenMarkets.firstWhereOrNull(
          (token) => token.symbol == config.config.evmInfo.symbol,
        ),
      ),
    );
  }

  void _onUpdateAccountBalance(
    HomePageOnUpdateAccountBalanceEvent event,
    Emitter<HomePageState> emit,
  ) async {
    try {
      List<AddBalanceRequest> requests = event.balanceMap.keys
          .toList()
          .map(
            (key) => AddBalanceRequest(
              balance: event.balanceMap[key]!,
              tokenId: state.auraMarket!.id,
              type: key.type,
            ),
          )
          .toList();

      final accountBalance = await _balanceUseCase.add(
        AddAccountBalanceRequest(
          accountId: state.activeAccount!.id,
          balances: requests,
        ),
      );

      emit(state.copyWith(
        accountBalance: accountBalance,
      ));
    } catch (e) {
      LogProvider.log(e.toString());
    }
  }

  void _sendMessageFetchTokenMarket() {
    _tokenSendPort?.send({
      'base_url_v1': config.config.api.v1.url,
    });
  }

  void _sendMessageFetchAccountBalance({
    required List<AppNetwork> networks,
  }) {
    _balanceSendPort?.send({
      'account': state.activeAccount!,
      'networks': networks,
    });
  }

  @override
  Future<void> close() {
    _mainTokenReceivePort.close();
    _mainBalanceReceivePort.close();
    _tokenIsolate.kill();
    _balanceIsolate.kill();
    // _nftIsolate.kill();
    return super.close();
  }
}
