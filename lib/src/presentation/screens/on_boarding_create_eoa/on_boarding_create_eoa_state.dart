import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'on_boarding_create_eoa_state.freezed.dart';

enum OnBoardingCreateEOAStatus {
  creating,
  created,
  error,
}

@freezed
class OnBoardingCreateEOAState with _$OnBoardingCreateEOAState {
  const factory OnBoardingCreateEOAState({
    @Default(OnBoardingCreateEOAStatus.creating)
    OnBoardingCreateEOAStatus status,
    PyxisWallet? auraWallet,
    String ?error,
  }) = _OnBoardingCreateEOAState;
}
