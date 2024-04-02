import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'signed_in_create_eoa_state.freezed.dart';

enum SignedInCreateEOAStatus {
  creating,
  created,
  error,
}

@freezed
class SignedInCreateEOAState with _$SignedInCreateEOAState {
  const factory SignedInCreateEOAState({
    @Default(SignedInCreateEOAStatus.creating)
    SignedInCreateEOAStatus status,
    PyxisWallet? auraWallet,
    String ?error,
  }) = _SignedInCreateEOAState;
}
