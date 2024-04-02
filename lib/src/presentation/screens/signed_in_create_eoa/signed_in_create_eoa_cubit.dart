import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signed_in_create_eoa_state.dart';

class SignedInCreateEOACubit extends Cubit<SignedInCreateEOAState> {
  final WalletUseCase _walletUseCase;

  SignedInCreateEOACubit(this._walletUseCase)
      : super(
          const SignedInCreateEOAState(),
        );

  void startCreate() async {
    emit(
      state.copyWith(
        status: SignedInCreateEOAStatus.creating,
      ),
    );

    await Future.delayed(
      const Duration(
        milliseconds: 1500,
      ),
    );

    try {
      final PyxisWallet pyxisWallet = await _walletUseCase.createWallet();

      emit(
        state.copyWith(
          auraWallet: pyxisWallet,
          status: SignedInCreateEOAStatus.created,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignedInCreateEOAStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
