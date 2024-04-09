import 'dart:ui';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/pyxis_wallet_core/pyxis_wallet_helper.dart';
import 'backup_private_key_state.dart';

class BackupPrivateKeyCubit extends Cubit<BackupPrivateKeyState> {
  final AuraAccountUseCase _auraAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  BackupPrivateKeyCubit(
    this._auraAccountUseCase,
    this._controllerKeyUseCase,
  ) : super(
          const BackupPrivateKeyState(),
        );

  void init({
    required VoidCallback onSuccess,
    required String address,
  }) async {
    final account = await _auraAccountUseCase.getAccountByAddress(
      address: address,
    );

    if (account != null) {
      await _auraAccountUseCase.updateAccount(
        id: account.id,
        needBackup: false,
      );

      final String? privateKeyOrPhrase = await _controllerKeyUseCase.getKey(
        address: account.address,
      );

      final String privateKey = PyxisWalletHelper.getPrivateKeyFromBytes(
        PyxisWalletHelper.getPrivateKeyFromString(privateKeyOrPhrase ?? ''),
      );

      onSuccess.call();

      emit(
        state.copyWith(
          privateKey: privateKey,
        ),
      );
    }
  }

  void showPrivateKey() {
    emit(
      state.copyWith(
        showPrivateKey: true,
      ),
    );
  }
}
