import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'on_boarding_import_normal_wallet_key_state.freezed.dart';

enum OnBoardingImportNormalWalletKeyStatus {
  init,
  onLoading,
  onImportAccountError,
  onImportAccountSuccess,
}

@freezed
class OnBoardingImportNormalWalletKeyState with _$OnBoardingImportNormalWalletKeyState {
  const factory OnBoardingImportNormalWalletKeyState({
    @Default(OnBoardingImportNormalWalletKeyStatus.init) OnBoardingImportNormalWalletKeyStatus status,
    @Default(ImportWalletType.privateKey) ImportWalletType importWalletType,
    @Default(false) bool isReadySubmit,
    @Default(false) bool showPrivateKey,
    @Default('') String key,
    @Default(false) bool isValidKey,
    String? errorMessage,
  }) = _OnBoardingImportNormalWalletKeyState;
}
