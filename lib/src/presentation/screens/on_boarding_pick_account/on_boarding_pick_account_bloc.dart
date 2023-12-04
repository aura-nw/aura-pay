import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart' show WalletUseCase, SmartAccountUseCase;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_pick_account_event.dart';
import 'on_boarding_pick_account_state.dart';

class OnBoardingPickAccountBloc
    extends Bloc<OnBoardingPickAccountEvent, OnBoardingPickAccountState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;

  OnBoardingPickAccountBloc(this._walletUseCase, this._smartAccountUseCase)
      : super(
          const OnBoardingPickAccountState(),
        ) {
    on(_onChangeAccountName);
    on(_onCreate);
  }

  void _onCreate(
    OnBoardingPickAccountOnSubmitEvent event,
    Emitter<OnBoardingPickAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OnBoardingPickAccountStatus.onLoading,
      ),
    );

    try {
      final wallet = await _walletUseCase.createWallet();

      final Random random = Random.secure();

      final int salt = random.nextInt(10000);

      final Uint8List saltBytes = Uint8List.fromList(
        utf8.encode(
          salt.toString(),
        ),
      );

      /// Create a smart account address
      final String smartAccount =
          await _smartAccountUseCase.generateSmartAccount(
        pubKey: wallet.publicKey,
        salt: saltBytes,
      );

      /// call api check fee gas

      bool isFreeFee = false;

      if (isFreeFee) {
        emit(state.copyWith(
          status: OnBoardingPickAccountStatus.onCheckAddressEnoughFee,
        ));
      } else {
        emit(
          state.copyWith(
            status: OnBoardingPickAccountStatus.onCheckAddressUnEnoughFee,
            smartAccountAddress: smartAccount,
            userPrivateKey: AuraWalletHelper.getPrivateKeyFromString(
              wallet.privateKey!,
            ),
            saltBytes: saltBytes,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingPickAccountStatus.onCheckAddressError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onChangeAccountName(
    OnBoardingPickAccountOnPickAccountChangeEvent event,
    Emitter<OnBoardingPickAccountState> emit,
  ) {
    emit(
      state.copyWith(
        accountName: event.accountName,
        isReadySubmit: event.accountName.isNotEmpty,
      ),
    );
  }
}
