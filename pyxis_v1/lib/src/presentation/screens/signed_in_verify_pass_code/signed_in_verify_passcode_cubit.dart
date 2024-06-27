import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/crypto_helper.dart';
import 'signed_in_verify_passcode_state.dart';

class SignedInVerifyPasscodeCubit extends Cubit<SignedInVerifyPasscodeStatus> {
  final AppSecureUseCase _appSecureUseCase;

  SignedInVerifyPasscodeCubit(this._appSecureUseCase)
      : super(
          SignedInVerifyPasscodeStatus.none,
        );

  void onVerifyPasscode(String passcode) async {
    final String? userPasscode = await _appSecureUseCase.getCurrentPassword(
      key: AppLocalConstant.passCodeKey,
    );

    String passCodeCompare = CryptoHelper.hashStringBySha256(passcode);

    if (userPasscode == passCodeCompare) {
      emit(
        SignedInVerifyPasscodeStatus.verifySuccess,
      );
    } else {
      emit(SignedInVerifyPasscodeStatus.verifyNotMatch);
    }
  }
}
