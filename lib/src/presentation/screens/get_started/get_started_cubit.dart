import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:domain/domain.dart';
import 'package:wallet_core/wallet_core.dart';

import 'get_started_state.dart';

/// Cubit managing the Get Started screen state and social login flow.
///
/// Handles authentication through Web3Auth providers (Google, Twitter, Apple)
/// and wallet creation from the authenticated private key.
final class GetStartedCubit extends Cubit<GetStartedState> {
  final Web3AuthUseCase _web3authUseCase;

  GetStartedCubit(this._web3authUseCase) : super(const GetStartedState());

  /// Handles social login flow using Web3Auth.
  ///
  /// Steps:
  /// 1. Authenticates user with the specified provider
  /// 2. Retrieves the private key from Web3Auth
  /// 3. Imports wallet using the private key
  /// 4. Logs out from Web3Auth (to clear session)
  /// 5. Emits success with the created wallet
  ///
  /// Throws [PlatformException] if authentication fails.
  Future<void> onLogin(Web3AuthLoginProvider provider) async {
    try {
      // Update state to indicate login is in progress
      emit(state.copyWith(status: GetStartedStatus.onSocialLogin));

      // Authenticate user with Web3Auth
      await _web3authUseCase.onLogin(provider: provider);

      // Retrieve the authenticated user's private key
      final privateKey = await _web3authUseCase.getPrivateKey();

      // Create wallet instance from private key
      final wallet = WalletCore.walletManagement.importWalletWithPrivateKey(
        privateKey,
        coinType: TWCoinType.TWCoinTypeEthereum,
      );

      // Clear Web3Auth session (we only need the private key)
      await _web3authUseCase.logout();

      // Emit success state with the created wallet
      emit(state.copyWith(
        status: GetStartedStatus.loginSuccess,
        wallet: wallet,
      ));
    } catch (e) {
      // Extract error message from exception
      final errorMessage = e is PlatformException 
          ? (e.message ?? e.toString())
          : e.toString();

      // Emit failure state with error message
      emit(state.copyWith(
        status: GetStartedStatus.loginFailure,
        error: errorMessage,
      ));
    }
  }
}

