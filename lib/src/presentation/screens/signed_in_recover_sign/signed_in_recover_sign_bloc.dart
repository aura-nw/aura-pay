import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'signed_in_recover_sign_event.dart';
import 'signed_in_recover_sign_state.dart';

final class SignedInRecoverSignBloc
    extends Bloc<SignedInRecoverSignEvent, SignedInRecoverSignState> {
  final Web3AuthUseCase _web3authUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;

  SignedInRecoverSignBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._web3authUseCase,
    this._accountUseCase, {
    required AuraAccount account,
    required GoogleAccount googleAccount,
  }) : super(
          SignedInRecoverSignState(
            account: account,
            googleAccount: googleAccount,
          ),
        ) {
    on(_onInit);
    on(_onChangeFee);
    on(_onConfirm);

    add(
      const SignedInRecoverSignEventOnInit(),
    );
  }

  final int _defaultGasLimit = 400000;

  void _onInit(
    SignedInRecoverSignEventOnInit event,
    Emitter<SignedInRecoverSignState> emit,
  ) async {
    // Set default gas
    final highFee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: AuraSmartAccountCache.deNom,
      gasPrice: GasPriceStep.high.value,
    );

    final fee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: AuraSmartAccountCache.deNom,
      gasPrice: GasPriceStep.average.value,
    );

    final lowFee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: AuraSmartAccountCache.deNom,
      gasPrice: GasPriceStep.low.value,
    );

    emit(
      state.copyWith(
        highTransactionFee: highFee.amount[0].amount,
        lowTransactionFee: lowFee.amount[0].amount,
        transactionFee: fee.amount[0].amount,
      ),
    );
  }

  void _onChangeFee(
    SignedInRecoverSignEventOnChangeFee event,
    Emitter<SignedInRecoverSignState> emit,
  ) async {
    emit(
      state.copyWith(
        transactionFee: event.fee,
        status: SignedInRecoverSignStatus.none,
      ),
    );
  }

  void _onConfirm(
    SignedInRecoverSignEventOnConfirm event,
    Emitter<SignedInRecoverSignState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SignedInRecoverSignStatus.onRecovering,
      ),
    );
    try {
      final String backupPrivateKey = await _web3authUseCase.getPrivateKey();

      final wallet = await _walletUseCase.importWallet(
        privateKeyOrPassPhrase: backupPrivateKey,
      );

      TransactionInformation information =
          await _smartAccountUseCase.recoverSmartAccount(
        privateKey: AuraWalletHelper.getPrivateKeyFromString(
          backupPrivateKey,
        ),
        recoverAddress: wallet.bech32Address,
        smartAccountAddress: state.account.address,
      );

      information = await _checkTransactionInfo(information.txHash, 0);

      await _web3authUseCase.onLogout();

      if (information.status == 0) {
        await _accountUseCase.updateAccount(
          id: state.account.id,
          method: null,
          useNullable: true,
        );

        await _controllerKeyUseCase.saveKey(
          address: state.account.address,
          key: backupPrivateKey,
        );

        emit(
          state.copyWith(
            status: SignedInRecoverSignStatus.onRecoverSuccess,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SignedInRecoverSignStatus.onRecoverFail,
            error: information.rawLog,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SignedInRecoverSignStatus.onRecoverFail,
          error: e.toString(),
        ),
      );
    }
  }

  Future<TransactionInformation> _checkTransactionInfo(
      String txHash, int times) async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    try {
      return await _smartAccountUseCase.getTx(
        txHash: txHash,
      );
    } catch (e) {
      if (times == 4) {
        rethrow;
      }
      return _checkTransactionInfo(txHash, times + 1);
    }
  }
}
