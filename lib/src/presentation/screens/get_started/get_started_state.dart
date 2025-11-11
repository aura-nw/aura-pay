import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet_services/wallet_services.dart';

part 'get_started_state.freezed.dart';

/// Status of the Get Started screen authentication flow.
enum GetStartedStatus {
  /// Initial state, no action taken
  none,
  
  /// Social login in progress
  onSocialLogin,
  
  /// Social login completed successfully
  loginSuccess,
  
  /// Social login failed
  loginFailure,
}

/// State for the Get Started screen.
///
/// Contains authentication status, created wallet, and error information.
@freezed
class GetStartedState with _$GetStartedState {
  const factory GetStartedState({
    @Default(GetStartedStatus.none) GetStartedStatus status,
    AWallet? wallet,
    String? error,
  }) = _GetStartedState;
}

