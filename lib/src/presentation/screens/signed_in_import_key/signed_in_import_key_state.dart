import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'signed_in_import_key_state.freezed.dart';

enum SignedInImportKeyStatus {
  init,
  onLoading,
  onImportAccountError,
  onImportAccountSuccess,
  existsAccount,
}

@freezed
class SignedInImportKeyState with _$SignedInImportKeyState {
  const factory SignedInImportKeyState({
    @Default(SignedInImportKeyStatus.init) SignedInImportKeyStatus status,
    @Default(ImportWalletType.privateKey) ImportWalletType importWalletType,
    @Default(PyxisWalletType.normalWallet) PyxisWalletType pyxisWalletType,
    @Default(false) bool isReadySubmit,
    @Default('') String key,
    @Default([]) List<AuraAccount> accounts,
    String? errorMessage,
  }) = _SignedInImportKeyState;
}
