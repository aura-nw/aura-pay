import 'package:freezed_annotation/freezed_annotation.dart';
part 'set_recovery_method_screen_event.freezed.dart';

@freezed
class SetRecoveryMethodScreenEvent with _$SetRecoveryMethodScreenEvent{
  const factory SetRecoveryMethodScreenEvent.onSet() = SetRecoveryMethodScreenEventOnSet;
  const factory SetRecoveryMethodScreenEvent.onChangeMethod(int index) = SetRecoveryMethodScreenEventOnChangeMethod;
}