import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurapay/src/core/constants/app_local_constant.dart';
import 'package:aurapay/src/core/constants/aura_pay_account_constant.dart';
import 'package:aurapay/src/core/helpers/crypto_initializer.dart';
import 'package:aurapay/src/core/error/error.dart';
import 'package:wallet_core/wallet_core.dart';
import 'generate_wallet_state.dart';

final class GenerateWalletCubit extends Cubit<GenerateWalletState> {
  final AccountUseCase _accountUseCase;
  final KeyStoreUseCase _keyStoreUseCase;

  GenerateWalletCubit(this._accountUseCase, this._keyStoreUseCase)
      : super(
          const GenerateWalletState(),
        );

  void generateWallet() async {
    emit(state.copyWith(
      status: GenerateWalletStatus.generating,
    ));

    try {
      // CRITICAL: Wait for crypto system to be ready before generating wallet
      // This prevents TrustWalletCore crashes on Android
      LogProvider.log('[GenerateWallet] Ensuring crypto system is ready...');
      await CryptoInitializer.ensureCryptoReady();
      LogProvider.log('[GenerateWallet] Crypto system ready, generating wallet...');
      
      // Add additional safety delay for Android
      await Future.delayed(const Duration(milliseconds: 500));
      
      final String mnemonic = WalletCore.walletManagement.randomMnemonic();
      LogProvider.log('[GenerateWallet] Mnemonic generated successfully');

      final AWallet aWallet = WalletCore.walletManagement.importWallet(mnemonic);
      LogProvider.log('[GenerateWallet] Wallet imported successfully');

      emit(state.copyWith(
        wallet: aWallet,
        status: GenerateWalletStatus.generated,
      ));
    } catch (e, stackTrace) {
      // Handle error with centralized error handler
      AppErrorHandler.handle(
        WalletException.walletGenerationFailed(e.toString()),
        stackTrace: stackTrace,
        customMessage: 'Failed to generate wallet. Please try restarting the app.',
      );
      
      // Emit error state
      emit(state.copyWith(
        status: GenerateWalletStatus.generated,
      ));
    }
  }

  void storeKey() async {
    emit(
      state.copyWith(
        status: GenerateWalletStatus.storing,
      ),
    );

    final String? key = WalletCore.storedManagement.saveWallet(
      AuraPayAccountConstant.defaultNormalWalletName,
      '',
      state.wallet!,
    );

    final keyStore = await _keyStoreUseCase.add(
      AddKeyStoreRequest(
        keyName: key!,
      ),
    );

    final String evmAddress = state.wallet!.address;

    final String cosmosAddress = bech32.convertEthAddressToBech32Address(
      AppLocalConstant.auraPrefix,
      evmAddress,
    );

    await _accountUseCase.add(
      AddAccountRequest(
        name: AuraPayAccountConstant.defaultNormalWalletName,
        addACosmosInfoRequest: AddACosmosInfoRequest(
          address: cosmosAddress,
          isActive: true,
        ),
        addAEvmInfoRequest: AddAEvmInfoRequest(
          address: evmAddress,
          isActive: true,
        ),
        createType: AccountCreateType.normal,
        type: AccountType.normal,
        keyStoreId: keyStore.id,
        controllerKeyType: ControllerKeyType.passPhrase,
        index: 0,
      ),
    );

    emit(
      state.copyWith(
        status: GenerateWalletStatus.stored,
      ),
    );
  }

  void updateStatus(bool isReady) {
    emit(
      state.copyWith(
        isReady: isReady,
      ),
    );
  }
}
