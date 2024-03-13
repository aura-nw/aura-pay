import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_create_eoa_state.dart';

class OnBoardingCreateEOACubit extends Cubit<OnBoardingCreateEOAState> {
  final WalletUseCase _walletUseCase;

  OnBoardingCreateEOACubit(this._walletUseCase)
      : super(
          const OnBoardingCreateEOAState(),
        );

  void startCreate() async {
    emit(
      state.copyWith(
        status: OnBoardingCreateEOAStatus.creating,
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
          status: OnBoardingCreateEOAStatus.created,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingCreateEOAStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
