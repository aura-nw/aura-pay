import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'setting_change_passcode_state.dart';

final class SettingChangePasscodeCubit
    extends Cubit<SettingChangePasscodeState> {
  final AppSecureUseCase _appSecureUseCase;

  SettingChangePasscodeCubit(this._appSecureUseCase)
      : super(
          const SettingChangePasscodeState(),
        );

  void onEnterPasscodeDone(List<String> passcode) async {
    final String? currentPasscode = await _appSecureUseCase.getCurrentPassword(
      key: AppLocalConstant.passCodeKey,
    );

    SettingChangePassCodeStatus status = passcode.join('') == currentPasscode
        ? SettingChangePassCodeStatus.enterPasscodeSuccessful
        : SettingChangePassCodeStatus.enterPasscodeWrong;

    emit(state.copyWith(
      status: status,
    ));
  }

  void onCreatePassCodeDone(List<String> newPasscodes) {
    emit(state.copyWith(
      status: SettingChangePassCodeStatus.createNewPassCodeDone,
      passCodes: List.empty(growable: true)..addAll(newPasscodes),
    ));
  }

  void onConfirmPassCodeDone(List<String> confirmPasscodes) async {
    String passCodes = state.passCodes.join('');

    SettingChangePassCodeStatus status = passCodes == confirmPasscodes.join('')
        ? SettingChangePassCodeStatus.confirmPassCodeSuccessful
        : SettingChangePassCodeStatus.confirmPasscodeWrong;

    if (status == SettingChangePassCodeStatus.confirmPassCodeSuccessful) {
      await _appSecureUseCase.savePassword(
        key: AppLocalConstant.passCodeKey,
        password: passCodes,
      );
    }

    emit(state.copyWith(
      status: status,
    ));
  }
}
