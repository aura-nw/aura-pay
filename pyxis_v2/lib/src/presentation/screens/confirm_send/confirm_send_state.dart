import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_send_state.freezed.dart';

enum ConfirmSendStatus {
  init,
  sending,
  sent,
  error,
}

@freezed
class ConfirmSendState with _$ConfirmSendState {
  const factory ConfirmSendState({
    @Default(ConfirmSendStatus.init) ConfirmSendStatus status,
    String? error,
    @Default('0') String fee,
    @Default('0') String highFee,
    @Default('0') String lowFee,
    required AppNetwork appNetwork,
    required Account account,
    required String amount,
    required String recipient,
    required Balance balance,
  }) = _ConfirmSendState;
}
