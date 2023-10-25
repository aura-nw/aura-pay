import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'on_boarding_import_key_event.freezed.dart';

@freezed
class OnBoardingImportKeyEvent with _$OnBoardingImportKeyEvent {
  const factory OnBoardingImportKeyEvent.onSelectAccountType({
    required PyxisWalletType accountType,
  }) = OnBoardingImportKeyOnSelectAccountTypeEvent;

  const factory OnBoardingImportKeyEvent.onSelectImportType({
    required ImportWalletType importType,
  }) = OnBoardingImportKeyOnSelectImportTypeEvent;

  const factory OnBoardingImportKeyEvent.onInputKey({
    required String key,
  }) = OnBoardingImportKeyOnInputKeyEvent;

  const factory OnBoardingImportKeyEvent.onSubmit() = OnBoardingImportKeyOnSubmitEvent;
}
