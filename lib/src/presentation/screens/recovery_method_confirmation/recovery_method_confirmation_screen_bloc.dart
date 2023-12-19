import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method_confirmation/recovery_method_confirmation_screen.dart';
import 'recovery_method_confirmation_screen_event.dart';
import 'recovery_method_confirmation_screen_state.dart';

final class RecoveryMethodConfirmationBloc extends Bloc<
    RecoveryMethodConfirmationEvent, RecoveryMethodConfirmationState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final WalletUseCase _walletUseCase;
  final Web3AuthUseCase _web3authUseCase;
  final AuraAccountUseCase _accountUseCase;

  RecoveryMethodConfirmationBloc(
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._walletUseCase,
    this._web3authUseCase,
    this._accountUseCase, {
    required RecoveryMethodConfirmationArgument argument,
  }) : super(
          RecoveryMethodConfirmationState(
            argument: argument,
          ),
        ) {
    on(_onInit);
    on(_onChangeFee);
    on(_onConfirm);

    add(
      const RecoveryMethodConfirmationEventOnInit(),
    );
  }

  final int _defaultGasLimit = 400000;

  void _onInit(
    RecoveryMethodConfirmationEventOnInit event,
    Emitter<RecoveryMethodConfirmationState> emit,
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
    RecoveryMethodConfirmationEventOnChangeFee event,
    Emitter<RecoveryMethodConfirmationState> emit,
  ) async {
    emit(
      state.copyWith(
        transactionFee: event.fee,
        status: RecoveryMethodConfirmationStatus.none,
      ),
    );
  }

  void _onConfirm(
    RecoveryMethodConfirmationEventOnConfirm event,
    Emitter<RecoveryMethodConfirmationState> emit,
  ) async {
    emit(
      state.copyWith(
        status: RecoveryMethodConfirmationStatus.onRecovering,
      ),
    );

    try {
      final AuraAccount account = state.argument.account;

      final String? smPrivateKey = await _controllerKeyUseCase.getKey(
        address: account.address,
      );

      String recoveryAddress = '';

      // Set account has method
      AuraSmartAccountRecoveryMethod method =
          AuraSmartAccountRecoveryMethod.web3Auth;
      String recoveryValue = '';

      if (state.argument is RecoveryMethodConfirmationGoogleArgument) {
        recoveryValue =
            (state.argument as RecoveryMethodConfirmationGoogleArgument)
                .data!
                .email;
        final String backupPrivateKey = await _web3authUseCase.getPrivateKey();

        final wallet = await _walletUseCase.importWallet(
          privateKeyOrPassPhrase: backupPrivateKey,
        );

        recoveryAddress = wallet.bech32Address;
      } else {
        method = AuraSmartAccountRecoveryMethod.backupAddress;
        recoveryAddress = state.argument.data;
        recoveryValue = state.argument.data;
      }

      TransactionInformation information =
          await _smartAccountUseCase.setRecoveryMethod(
        userPrivateKey: AuraWalletHelper.getPrivateKeyFromString(smPrivateKey!),
        smartAccountAddress: account.address,
        recoverAddress: recoveryAddress,
        gasLimit: _defaultGasLimit,
        fee: state.transactionFee,
      );

      information = await _checkTransactionInfo(information.txHash, 0);

      if (information.status == 0) {
        await _accountUseCase.updateAccount(
          id: account.id,
          method: method,
          value: recoveryValue,
        );

        emit(
          state.copyWith(
            status: RecoveryMethodConfirmationStatus.onRecoverSuccess,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: RecoveryMethodConfirmationStatus.onRecoverFail,
            error: information.rawLog,
          ),
        );
      }

      await _web3authUseCase.onLogout();
    } catch (e) {
      emit(
        state.copyWith(
          status: RecoveryMethodConfirmationStatus.onRecoverFail,
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
