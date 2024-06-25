import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'signed_in_import_normal_wallet_key_state.freezed.dart';

enum SignedInImportNormalWalletKeyStatus {
  init,
  onLoading,
  onImportAccountError,
  onImportAccountSuccess,
  existsAccount,
}

@freezed
class SignedInImportNormalWalletKeyState with _$SignedInImportNormalWalletKeyState {
  const factory SignedInImportNormalWalletKeyState({
    @Default(SignedInImportNormalWalletKeyStatus.init) SignedInImportNormalWalletKeyStatus status,
    @Default(ImportWalletType.privateKey) ImportWalletType importWalletType,
    @Default(false) bool isReadySubmit,
    @Default(false) bool showPrivateKey,
    @Default('') String key,
    String? errorMessage,
    @Default([]) List<AuraAccount> accounts,
  }) = _SignedInImportNormalWalletKeyState;
}
