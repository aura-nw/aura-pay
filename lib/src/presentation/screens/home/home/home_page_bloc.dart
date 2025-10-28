import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:aurapay/app_configs/aura_pay_config.dart';
import 'package:aurapay/src/core/constants/app_local_constant.dart';
import 'package:aurapay/src/core/factory_creator/account_balance.dart';
import 'package:aurapay/src/core/factory_creator/dio.dart';
import 'package:aurapay/src/core/factory_creator/isar.dart';
import 'package:aurapay/src/core/factory_creator/nft.dart';
import 'package:aurapay/src/core/factory_creator/token_market.dart';
import 'package:aurapay/src/core/utils/aura_util.dart';
import 'package:aurapay/src/core/utils/dart_core_extension.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';

final class _BackgroundThreadParam {
  final String type;
  final Map<String, dynamic> message;

  const _BackgroundThreadParam({required this.message, required this.type});
}

final class _BackgroundThreadResultData {
  final String type;
  final dynamic result;

  const _BackgroundThreadResultData({required this.type, required this.result});
}

final class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final TokenMarketUseCase _tokenMarketUseCase;
  final BalanceUseCase _balanceUseCase;
  final AccountUseCase _accountUseCase;
  final AuraPayConfig config;
  final TokenUseCase _tokenUseCase;

  HomePageBloc(
    this._tokenUseCase,
    this._accountUseCase,
    this._tokenMarketUseCase,
    this._balanceUseCase, {
    required this.config,
  }) : super(const HomePageState()) {
    _initMultiThread();
    on(_loadStorageData);
    on(_onUpdateTokenMarket);
    on(_onUpdateAccountBalance);
    on(_onUpdateNFTs);
    on(_onChangeEnableToken);
    on(_onRefreshTokenBalance);
  }

  static const String fetchAccountBalance = 'fetch_account_balance';
  static const String fetchAccountNft = 'fetch_account_nft';
  static const String fetchTokenMarket = 'fetch_token_market';

  bool _isTokenMarketMsg(String type) => type == fetchTokenMarket;

  bool _isAccountNftMsg(String type) => type == fetchAccountNft;

  bool _isAccountBalanceMsg(String type) => type == fetchAccountBalance;

  late Isolate _isolate;
  late ReceivePort _mainReceivePort;
  late SendPort? _mainSendPort;
  StreamSubscription? _subscription;

  /// init multi thread
  void _initMultiThread() async {
    _mainReceivePort = ReceivePort();

    _isolate = await Isolate.spawn(_backgroundFetch, _mainReceivePort.sendPort);
    // Listen to the stream only once
    _subscription = _mainReceivePort.listen((message) {
      if (message is Map<String, dynamic>) {
        if (message.containsKey('send_port')) {
          // receive isolateSendPort from token thread
          _mainSendPort = message['send_port'] as SendPort;

          add(const HomePageOnGetStorageDataEvent());

          _sendMsgs([fetchTokenMarket]);
        } else if (message.containsKey('token_market')) {
          add(
            HomePageOnUpdateTokenMarketEvent(
              tokenMarkets: message['token_market'],
            ),
          );
        } else if (message.containsKey('balanceMap')) {
          add(
            HomePageOnUpdateAccountBalanceEvent(
              balanceMap: message['balanceMap'],
            ),
          );
        } else if (message.containsKey('nftS')) {
          add(HomePageOnUpdateNFTsEvent(nftS: message['nftS']));
        } else {
          LogProvider.log('fetch market token error ${message['error']}');
        }
      }
    });
  }

  static void _backgroundFetch(SendPort sendPort) async {
    ReceivePort receivePort = ReceivePort();

    sendPort.send({'send_port': receivePort.sendPort});

    Future<void> handleMsgs(List<_BackgroundThreadParam> params) async{
      for(final param in params){
        final type = param.type;

        final Map<String,dynamic> message = param.message;

        try{
          if(type == HomePageBloc.fetchTokenMarket){
            final String urlV1 = message['base_url_v1'];
            final Dio dio = dioFactory(urlV1);

            final Isar isar = await getIsar();

            final TokenMarketUseCase tokenMarketUseCase = tokenMarketFactory(
              dio,
              isar,
            );

            await _fetchTokenMarket(tokenMarketUseCase, sendPort);

            continue;
          }

          if(type == HomePageBloc.fetchAccountBalance){
            final Isar isar = await getIsar();

            final Dio dio = dioFactory(message['base_url_v2']);

            final BalanceUseCase balanceUseCase = balanceFactory(isar, dio);

            await _fetchBalance(balanceUseCase, sendPort, message);

            continue;
          }

          if(type == HomePageBloc.fetchAccountNft){
            final Dio dio = dioFactory(message['base_url_v2']);

            final NftUseCase nftUseCase = nftUseCaseFactory(dio);

            await _fetchNFT(nftUseCase, sendPort, message);

            continue;
          }
        }catch(error){
          sendPort.send({'error': error.toString()});
        }
      }
    }

    await for (final message in receivePort) {
      if (message is List<_BackgroundThreadParam>) {
        await handleMsgs(message);
      }
    }
  }

  static Future<void> _fetchTokenMarket(
    TokenMarketUseCase tokenMarketUseCase,
    SendPort sendPort,
  ) async {
    try {
      final tokenMarkets = await tokenMarketUseCase.getRemoteTokenMarket();

      sendPort.send({'token_market': tokenMarkets});

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
        address: account.aEvmInfo.address,
      );

      result[TokenType.native] = amount;

      final erc20TokenBalances = await balanceUseCase.getErc20TokenBalance(
        request: QueryERC20BalanceRequest(
          address: account.aCosmosInfo.address,
          environment: environment,
        ),
      );

      result[TokenType.erc20] = erc20TokenBalances;

      final cw20TokenBalances = await balanceUseCase.getCw20TokenBalance(
        request: QueryCW20BalanceRequest(
          address: account.aCosmosInfo.address,
          environment: environment,
        ),
      );

      result[TokenType.cw20] = cw20TokenBalances;

      sendPort.send({'balanceMap': result});
    } catch (e) {
      // Send the error back to the main isolate
      sendPort.send({'error': e.toString()});
    }
  }

  static Future<void> _fetchNFT(
    NftUseCase nftUseCase,
    SendPort sendPort,
    Map<String, dynamic> message,
  ) async {
    try {
      final Account account = message['account'];

      final String environment = message['environment'];

      final List<NFTInformation> erc721s = await nftUseCase.queryNFTs(
        QueryERC721Request(
          owner: account.aEvmInfo.address.toLowerCase(),
          environment: environment,
          limit: 4,
        ),
      );

      final List<NFTInformation> cw721s = await nftUseCase.queryNFTs(
        QueryCW721Request(
          owner: account.aCosmosInfo.address.toLowerCase(),
          environment: environment,
          limit: 4,
        ),
      );

      sendPort.send({
        'nftS': [...erc721s, ...cw721s],
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
      final tokens = await _tokenUseCase.getAll();

      final activeAccount = await _accountUseCase.getFirstAccount();

      emit(state.copyWith(activeAccount: activeAccount, tokens: tokens));

      _sendMsgs([fetchAccountBalance,fetchAccountNft], activeAccount: activeAccount);

      final tokenMarkets = await _tokenMarketUseCase.getAll();

      emit(state.copyWith(tokenMarkets: tokenMarkets));

      final accountBalance = await _balanceUseCase.getByAccountID(
        accountId: activeAccount!.id,
      );

      emit(
        state.copyWith(
          accountBalance: accountBalance,
          totalTokenValue: _calculateBalance(accountBalance)[0],
          totalValue: _calculateBalance(accountBalance)[0],
          totalValueYesterday: _calculateBalance(accountBalance)[1],
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
    emit(state.copyWith(tokenMarkets: event.tokenMarkets));
  }

  void _onUpdateAccountBalance(
    HomePageOnUpdateAccountBalanceEvent event,
    Emitter<HomePageState> emit,
  ) async {
    try {
      List<AddBalanceRequest> requests = [];

      final nativeAmount = event.balanceMap[TokenType.native];
      if (nativeAmount != null) {
        Token? token = state.tokens.firstWhereOrNull(
          (token) => token.type == TokenType.native,
        );

        token ??= await _tokenUseCase.add(
          AddTokenRequest(
            logo: AppLocalConstant.auraLogo,
            tokenName: config.config.nativeCoin.name,
            type: TokenType.native,
            symbol: config.config.nativeCoin.symbol,
            contractAddress: '',
            isEnable: true,
          ),
        );

        requests.add(
          AddBalanceRequest(balance: nativeAmount, tokenId: token.id),
        );
      }

      final List<ErcTokenBalance> ercTokenBalances =
          event.balanceMap[TokenType.erc20] ?? <ErcTokenBalance>[];

      // Add erc token
      for (final erc in ercTokenBalances) {
        Token? token = state.tokens.firstWhereOrNull(
          (token) => token.contractAddress == erc.denom,
        );

        if (token == null) {
          final tokenMarket = state.tokenMarkets.firstWhereOrNull(
            (token) => token.denom == erc.denom,
          );

          token = await _tokenUseCase.add(
            AddTokenRequest(
              logo: tokenMarket?.image ?? AppLocalConstant.auraLogo,
              tokenName: tokenMarket?.name ?? '',
              type: TokenType.erc20,
              symbol: tokenMarket?.symbol ?? '',
              contractAddress: erc.denom,
              isEnable: true,
              decimal: tokenMarket?.decimal,
            ),
          );
        }

        requests.add(AddBalanceRequest(balance: erc.amount, tokenId: token.id));
      }

      // Add cw 20 token
      final List<Cw20TokenBalance> cwTokenBalances =
          event.balanceMap[TokenType.cw20] ?? <Cw20TokenBalance>[];

      for (final cw in cwTokenBalances) {
        Token? token = state.tokens.firstWhereOrNull(
          (token) => token.contractAddress == cw.contract.smartContract.address,
        );

        if (token == null) {
          final tokenMarket = state.tokenMarkets.firstWhereOrNull(
            (token) => token.symbol == cw.contract.symbol,
          );

          token = await _tokenUseCase.add(
            AddTokenRequest(
              logo: tokenMarket?.image ?? AppLocalConstant.auraLogo,
              tokenName: tokenMarket?.name ?? cw.contract.name,
              type: TokenType.cw20,
              symbol: tokenMarket?.symbol ?? cw.contract.symbol,
              contractAddress: cw.contract.smartContract.address,
              isEnable: true,
              decimal:
                  int.tryParse(cw.contract.decimal ?? '') ??
                  tokenMarket?.decimal,
            ),
          );
        }

        requests.add(AddBalanceRequest(balance: cw.amount, tokenId: token.id));
      }

      if (state.accountBalance != null) {
        await _balanceUseCase.delete(state.accountBalance!.id);
      }

      final accountBalance = await _balanceUseCase.add(
        AddAccountBalanceRequest(
          accountId: state.activeAccount!.id,
          balances: requests,
        ),
      );

      final tokens = await _tokenUseCase.getAll();

      emit(
        state.copyWith(
          accountBalance: accountBalance,
          totalTokenValue: _calculateBalance(accountBalance)[0],
          totalValue: _calculateBalance(accountBalance)[0],
          totalValueYesterday: _calculateBalance(accountBalance)[1],
          tokens: tokens,
        ),
      );
    } catch (e) {
      LogProvider.log(e.toString());
    }
  }

  void _onUpdateNFTs(
    HomePageOnUpdateNFTsEvent event,
    Emitter<HomePageState> emit,
  ) {
    final List<NFTInformation> nftS = List.empty(growable: true);

    nftS.addAll(event.nftS);

    nftS.sort((a, b) {
      return a.lastUpdatedHeight - b.lastUpdatedHeight;
    });

    if (nftS.length >= 4) {
      emit(state.copyWith(nftS: nftS.getRange(0, 3).toList()));
    } else {
      emit(state.copyWith(nftS: nftS));
    }
  }

  void _onChangeEnableToken(
    HomePageOnUpdateEnableTotalTokenEvent event,
    Emitter<HomePageState> emit,
  ) {
    emit(state.copyWith(enableToken: !state.enableToken));
  }

  void _sendMsgs(List<String> msgs,{ Account? activeAccount}) {
    final List<_BackgroundThreadParam> params = [];

    for (final msg in msgs) {
      if (_isTokenMarketMsg(msg)) {
        params.add(
          _BackgroundThreadParam(
            message: {'base_url_v1': config.config.api.v1.url},
            type: msg,
          ),
        );
        continue;
      }

      if (_isAccountBalanceMsg(msg)) {
        params.add(
          _BackgroundThreadParam(
            message: {
              'account': activeAccount ?? state.activeAccount!,
              'base_url_v2': config.config.api.v2.url,
              'environment': config.environment.environmentString,
            },
            type: msg,
          ),
        );
        continue;
      }

      if (_isAccountNftMsg(msg)) {
        params.add(
          _BackgroundThreadParam(
            message: {
              'account': activeAccount ?? state.activeAccount!,
              'base_url_v2': config.config.api.v2.url,
              'environment': config.environment.environmentString,
            },
            type: msg,
          ),
        );
        continue;
      }
    }

    if(params.isNotEmpty){
      _mainSendPort?.send(params);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _subscription = null;
    _mainSendPort = null;
    _mainReceivePort.close();
    _isolate.kill();
    return super.close();
  }

  List<double> _calculateBalance(AccountBalance? accountBalance) {
    // If accountBalance is null, return [0, 0] indicating no balance or previous value.
    if (accountBalance == null) return [0, 0];

    double totalBalance = 0; // Initialize total balance for today.
    double totalValueYesterday = 0.0; // Initialize total balance for yesterday.

    // Iterate over each balance in the accountBalance.
    for (final balance in accountBalance.balances) {
      // Find the corresponding token information using tokenId.
      final token = state.tokens.firstWhereOrNull(
        (e) => e.id == balance.tokenId,
      );

      final tokenMarket = state.tokenMarkets.firstWhereOrNull(
        (e) => e.symbol == token?.symbol,
      );

      // Parse the amount of the token balance using a custom decimal format if provided.
      final amount =
          double.tryParse(
            token?.type.formatBalance(
                  balance.balance,
                  customDecimal: token.decimal,
                ) ??
                '',
          ) ??
          0;

      // Parse the current price of the token, default to 0 if the price is null or not parsable.
      double currentPrice =
          double.tryParse(tokenMarket?.currentPrice ?? '0') ?? 0;

      // Calculate the price of the token yesterday.
      double priceYesterday =
          currentPrice /
          (1 + (tokenMarket?.priceChangePercentage24h ?? 0) / 100);

      // If the amount or priceYesterday is not zero, add to the total value of yesterday.
      if (amount != 0 || priceYesterday != 0) {
        totalValueYesterday += priceYesterday * amount;
      }

      // If the amount and current price are not zero, add to the total balance for today.
      if (amount != 0 && currentPrice != 0) {
        totalBalance += amount * currentPrice;
      }
    }

    // Return a list with total balance for today and total value for yesterday.
    return [totalBalance, totalValueYesterday];
  }

  void _onRefreshTokenBalance(
    HomePageOnRefreshTokenBalanceEvent event,
    Emitter<HomePageState> emit,
  ) {
    switch (event.tokenType) {
      case TokenType.native:
        break;
      case TokenType.cw20:
        break;
      case TokenType.erc20:
        break;
    }
  }
}
