import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'singed_in_import_key_event.freezed.dart';

@freezed
class SignedInImportKeyEvent with _$SignedInImportKeyEvent {
  const factory SignedInImportKeyEvent.onInit() = SignedInImportKeyOnInit;

  const factory SignedInImportKeyEvent.onSelectAccountType({
    required PyxisWalletType accountType,
  }) = SignedInImportKeyOnSelectAccountTypeEvent;

  const factory SignedInImportKeyEvent.onSelectImportType({
    required ImportWalletType importType,
  }) = SignedInImportKeyOnSelectImportTypeEvent;

  const factory SignedInImportKeyEvent.onInputKey({
    required String key,
  }) = SignedInImportKeyOnInputKeyEvent;

  const factory SignedInImportKeyEvent.onSubmit() =
      SignedInImportKeyOnSubmitEvent;
}
