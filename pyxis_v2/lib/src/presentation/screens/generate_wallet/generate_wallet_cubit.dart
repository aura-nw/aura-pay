import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_v2/src/core/constants/pyxis_account_constant.dart';
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

    final String mnemonic = WalletCore.walletManagement.randomMnemonic();

    final AWallet aWallet = WalletCore.walletManagement.importWallet(mnemonic);

    emit(state.copyWith(
      wallet: aWallet,
      status: GenerateWalletStatus.generated,
    ));
  }

  void storeKey() async {
    emit(
      state.copyWith(
        status: GenerateWalletStatus.storing,
      ),
    );

    final String? key = WalletCore.storedManagement.saveWallet(
      PyxisAccountConstant.defaultNormalWalletName,
      '',
      state.wallet!,
    );

    final keyStore = await _keyStoreUseCase.add(
      AddKeyStoreRequest(
        keyName: key!,
      ),
    );

    await _accountUseCase.add(
      AddAccountRequest(
        name: PyxisAccountConstant.defaultNormalWalletName,
        evmAddress: state.wallet!.address,
        keyStoreId: keyStore.id,
        controllerKeyType: ControllerKeyType.passPhrase,
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
