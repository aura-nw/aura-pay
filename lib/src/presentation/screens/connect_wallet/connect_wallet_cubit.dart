import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

import 'connect_wallet_state.dart';

class ConnectWalletCubit extends Cubit<ConnectWalletState> {
  final AuraAccountUseCase _auraAccountUseCase;

  ConnectWalletCubit(this._auraAccountUseCase)
      : super(
          const ConnectWalletState(),
        ) {
    onInit();
  }

  void onInit() async {
    emit(
      state.copyWith(
        status: ConnectWalletStatus.loading,
      ),
    );

    final accounts = await _auraAccountUseCase.getAccounts();

    emit(
      state.copyWith(
        status: ConnectWalletStatus.loaded,
        accounts: accounts,
        choosingAccount: accounts.firstWhereOrNull(
          (e) => e.index == 0,
        ),
      ),
    );
  }

  void onChoseNewAccount(AuraAccount account) async {
    if (state.choosingAccount?.id == account.id) return;

    emit(
      state.copyWith(
        choosingAccount: account,
      ),
    );

    await Future.delayed(const Duration(
      seconds: 2,
    ));

    final accounts = await _auraAccountUseCase.getAccounts();

    emit(
      state.copyWith(
        accounts: accounts,
        choosingAccount: accounts.firstWhereOrNull(
              (e) => e.index == 0,
        ),
      ),
    );
  }
}
