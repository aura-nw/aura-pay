import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'controller_key_management_state.freezed.dart';

enum ControllerKeyManagementStatus {
  loading,
  loaded,
  error,
}

@freezed
class ControllerKeyManagementState with _$ControllerKeyManagementState {
  const factory ControllerKeyManagementState({
    @Default(ControllerKeyManagementStatus.loading)
    ControllerKeyManagementStatus status,
    @Default([]) List<AuraAccount> accounts,
  }) = _ControllerKeyManagementState;
}
