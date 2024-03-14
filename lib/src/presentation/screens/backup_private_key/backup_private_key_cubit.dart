import 'dart:ui';

import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  }) async {
    final account = await _auraAccountUseCase.getFirstAccount();

    if (account != null) {
      await _auraAccountUseCase.updateAccount(
        id: account.id,
        needBackup: false,
      );

      final String? privateKey = await _controllerKeyUseCase.getKey(
        address: account.address,
      );

      onSuccess.call();

      emit(
        state.copyWith(
          privateKey: privateKey ?? state.privateKey,
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
