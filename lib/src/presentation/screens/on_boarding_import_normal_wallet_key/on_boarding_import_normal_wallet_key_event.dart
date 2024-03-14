import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'on_boarding_import_normal_wallet_key_event.freezed.dart';

@freezed
class OnBoardingImportNormalWalletKeyEvent with _$OnBoardingImportNormalWalletKeyEvent {
  const factory OnBoardingImportNormalWalletKeyEvent.onSelectImportType({
    required ImportWalletType importType,
  }) = OnBoardingImportNormalWalletKeyOnSelectImportTypeEvent;

  const factory OnBoardingImportNormalWalletKeyEvent.onInputKey({
    required String key,
  }) = OnBoardingImportNormalWalletKeyOnInputKeyEvent;

  const factory OnBoardingImportNormalWalletKeyEvent.onChangeShowPrivateKey() = OnBoardingImportNormalWalletKeyOnChangeShowPrivateKeyEvent;

  const factory OnBoardingImportNormalWalletKeyEvent.onSubmit() = OnBoardingImportNormalWalletKeyOnSubmitEvent;
}
