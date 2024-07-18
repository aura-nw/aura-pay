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

  final List<AppNetwork> _allNetworks = List.empty(growable: true);

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

          final Dio dio = dioFactory(
            message['base_url_v2'],
          );

          final BalanceUseCase balanceUseCase = balanceFactory(isar, dio);

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
      final Account account = message['account'];

      final String environment = message['environment'];

      Map<TokenType, dynamic> result = {};

      String amount = await balanceUseCase.getNativeBalance(
        address: account.evmAddress,
      );

      result[TokenType.native] = amount;

      final erc20TokenBalances = await balanceUseCase.getErc20TokenBalance(
        request: QueryERC20BalanceRequest(
          address: account.evmAddress,
          environment: environment,
        ),
      );

      result[TokenType.erc20] = erc20TokenBalances;

      final cw20TokenBalances = await balanceUseCase.getCw20TokenBalance(
        request: QueryCW20BalanceRequest(
          address: account.evmAddress,
          environment: environment,
        ),
      );

      result[TokenType.cw20] = cw20TokenBalances;

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

      _allNetworks.addAll(networks);

      emit(
        state.copyWith(
          activeNetworks: networks,
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

      _sendMessageFetchAccountBalance();

      final tokenMarkets = await _tokenMarketUseCase.getAll();

      final accountBalance = await _balanceUseCase.getByAccountID(
        accountId: activeAccount!.id,
      );

      emit(
        state.copyWith(
          tokenMarkets: tokenMarkets,
          accountBalance: accountBalance,
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
      ),
    );
  }

  void _onUpdateAccountBalance(
    HomePageOnUpdateAccountBalanceEvent event,
    Emitter<HomePageState> emit,
  ) async {
    try {
      List<AddBalanceRequest> requests = [];

      final nativeAmount = event.balanceMap[TokenType.native];
      if (nativeAmount != null) {
        final nativeToken = state.tokenMarkets.firstWhereOrNull(
          (token) => token.symbol == config.config.evmInfo.symbol,
        );

        if (nativeToken != null) {
          requests.add(
            AddBalanceRequest(
              balance: nativeAmount,
              tokenId: nativeToken.id,
              type: TokenType.native.name,
            ),
          );
        }
      }

      final List<ErcTokenBalance> ercTokenBalances =
          event.balanceMap[TokenType.erc20] ?? <ErcTokenBalance>[];

      // Add erc token
      for (final erc in ercTokenBalances) {
        final ercToken = state.tokenMarkets.firstWhereOrNull(
          (token) => token.symbol == erc.denom,
        );

        if (ercToken != null) {
          requests.add(AddBalanceRequest(
            balance: erc.amount,
            tokenId: ercToken.id,
            type: TokenType.erc20.name,
          ));
        }
      }

      // Add cw 20 token
      final List<Cw20TokenBalance> cwTokenBalances =
          event.balanceMap[TokenType.cw20] ?? <Cw20TokenBalance>[];

      for (final cw in cwTokenBalances) {
        final cwToken = state.tokenMarkets.firstWhereOrNull(
              (token) => token.symbol == cw.contract.symbol,
        );

        if (cwToken != null) {
          requests.add(AddBalanceRequest(
            balance: cw.amount,
            tokenId: cwToken.id,
            type: TokenType.cw20.name,
          ));
        }
      }


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

  void _sendMessageFetchAccountBalance() {
    _balanceSendPort?.send({
      'account': state.activeAccount!,
      'base_url_v2': config.config.api.v2.url,
      'environment': config.environment.environmentString,
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
