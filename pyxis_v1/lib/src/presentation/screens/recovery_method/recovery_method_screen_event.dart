import 'package:freezed_annotation/freezed_annotation.dart';
part 'recovery_method_screen_event.freezed.dart';

@freezed
class RecoveryMethodScreenEvent with _$RecoveryMethodScreenEvent{
  const factory RecoveryMethodScreenEvent.fetchAccount() = RecoveryMethodScreenEventFetchAccount;
  const factory RecoveryMethodScreenEvent.refresh() = RecoveryMethodScreenEventRefresh;
}