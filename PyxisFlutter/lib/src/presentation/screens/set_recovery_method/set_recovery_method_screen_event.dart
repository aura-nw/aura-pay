import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
part 'set_recovery_method_screen_event.freezed.dart';

@freezed
class SetRecoveryMethodScreenEvent with _$SetRecoveryMethodScreenEvent{
  const factory SetRecoveryMethodScreenEvent.onSet() = SetRecoveryMethodScreenEventOnSet;
  const factory SetRecoveryMethodScreenEvent.onChangeMethod(RecoverOptionType type) = SetRecoveryMethodScreenEventOnChangeMethod;
  const factory SetRecoveryMethodScreenEvent.onChangeRecoveryAddress(String address,bool isReady) = SetRecoveryMethodScreenEventOnChangeRecoveryAddress;
}