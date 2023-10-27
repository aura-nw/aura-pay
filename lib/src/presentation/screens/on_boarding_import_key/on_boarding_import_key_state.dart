import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'on_boarding_import_key_state.freezed.dart';

enum OnBoardingImportKeyStatus {
  init,
  onLoading,
  onImportAccountError,
  onImportAccountSuccess,
}

@freezed
class OnBoardingImportKeyState with _$OnBoardingImportKeyState {
  const factory OnBoardingImportKeyState({
    @Default(OnBoardingImportKeyStatus.init) OnBoardingImportKeyStatus status,
    @Default(ImportWalletType.privateKey) ImportWalletType importWalletType,
    @Default(PyxisWalletType.smartAccount) PyxisWalletType pyxisWalletType,
    @Default(false) bool isReadySubmit,
    @Default('') String key,
    String? errorMessage,
  }) = _OnBoardingImportKeyState;
}
