import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'on_boarding_recover_sign_state.freezed.dart';

enum OnBoardingRecoverSignStatus {
  none,
  onRecovering,
  onRecoverSuccess,
  onRecoverFail,
}

@freezed
class OnBoardingRecoverSignState with _$OnBoardingRecoverSignState {
  const factory OnBoardingRecoverSignState({
    required GoogleAccount googleAccount,
    required AuraAccount account,
    @Default(OnBoardingRecoverSignStatus.none)
    OnBoardingRecoverSignStatus status,
    String ?error,
    @Default('') String transactionFee,
    @Default('') String highTransactionFee,
    @Default('') String lowTransactionFee,
  }) = _OnBoardingRecoverSignState;
}