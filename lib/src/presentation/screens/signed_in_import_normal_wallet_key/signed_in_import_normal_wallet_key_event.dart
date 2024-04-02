import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'signed_in_import_normal_wallet_key_event.freezed.dart';

@freezed
class SignedInImportNormalWalletKeyEvent with _$SignedInImportNormalWalletKeyEvent {
  const factory SignedInImportNormalWalletKeyEvent.onSelectImportType({
    required ImportWalletType importType,
  }) = SignedInImportNormalWalletKeyOnSelectImportTypeEvent;

  const factory SignedInImportNormalWalletKeyEvent.onInputKey({
    required String key,
    required bool isValid,
  }) = SignedInImportNormalWalletKeyOnInputKeyEvent;

  const factory SignedInImportNormalWalletKeyEvent.onChangeShowPrivateKey() = SignedInImportNormalWalletKeyOnChangeShowPrivateKeyEvent;

  const factory SignedInImportNormalWalletKeyEvent.onSubmit() = SignedInImportNormalWalletKeyOnSubmitEvent;
}
