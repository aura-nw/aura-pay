import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'send_event.dart';
import 'send_state.dart';

final class SendBloc extends Bloc<SendEvent, SendState> {
  final TokenMarketUseCase _tokenMarketUseCase;
  final BalanceUseCase _balanceUseCase;
  final AccountUseCase _accountUseCase;

  SendBloc(
    this._accountUseCase,
    this._balanceUseCase,
    this._tokenMarketUseCase, {
    required List<AppNetwork> appNetworks,
  }) : super(
          SendState(
            appNetworks: appNetworks,
            selectedNetwork: appNetworks[0],
          ),
        ) {
    on(_onInit);
    on(_onChangeSaved);
    on(_onChangeNetwork);
  }

  void _onInit(SendOnInitEvent event, Emitter<SendState> emit) async {
    emit(
      state.copyWith(
        status: SendStatus.loading,
      ),
    );

    try {
      final account = await _accountUseCase.getFirstAccount();

      emit(
        state.copyWith(
          account: account,
          status: SendStatus.loaded,
        ),
      );

      final accountBalance = await _balanceUseCase.getByAccountID(
        accountId: account!.id,
      );

      emit(
        state.copyWith(
          status: SendStatus.loaded,
          accountBalance: accountBalance,
        ),
      );

      List<TokenMarket> tokenMarkets = await _tokenMarketUseCase.getAll();

      if (tokenMarkets.isEmpty) {
        tokenMarkets = await _tokenMarketUseCase.getRemoteTokenMarket();
      }

      emit(
        state.copyWith(
          status: SendStatus.loaded,
          tokenMarkets: tokenMarkets,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SendStatus.error,
        ),
      );
    }
  }

  void _onChangeSaved(SendOnChangeSavedEvent event, Emitter<SendState> emit) {
    emit(
      state.copyWith(
        isSaved: !state.isSaved,
      ),
    );
  }

  void _onChangeNetwork(SendOnChangeNetworkEvent event, Emitter<SendState> emit) {
    emit(
      state.copyWith(
        selectedNetwork: event.network,
      ),
    );
  }
}
