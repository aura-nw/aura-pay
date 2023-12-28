import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'recovery_method_confirmation_screen.dart';
import 'recovery_method_confirmation_screen_event.dart';
import 'recovery_method_confirmation_screen_state.dart';

final class RecoveryMethodConfirmationBloc extends Bloc<
    RecoveryMethodConfirmationEvent, RecoveryMethodConfirmationState> {
  final SmartAccountUseCase _smartAccountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final WalletUseCase _walletUseCase;
  final Web3AuthUseCase _web3authUseCase;
  final AuraAccountUseCase _accountUseCase;
  final TransactionUseCase _transactionUseCase;

  RecoveryMethodConfirmationBloc(
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._walletUseCase,
    this._web3authUseCase,
    this._accountUseCase,
    this._transactionUseCase, {
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

  final config = getIt.get<PyxisMobileConfig>();

  final int _defaultGasLimit = 400000;

  void _onInit(
    RecoveryMethodConfirmationEventOnInit event,
    Emitter<RecoveryMethodConfirmationState> emit,
  ) async {
    // Set default gas
    final highFee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: config.deNom,
      gasPrice: GasPriceStep.high.value,
    );

    final fee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: config.deNom,
      gasPrice: GasPriceStep.average.value,
    );

    final lowFee = CosmosHelper.calculateFee(
      _defaultGasLimit,
      deNom: config.deNom,
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
        gasLimit: state.argument.account.isVerified
            ? (1.5 * _defaultGasLimit).round()
            : _defaultGasLimit,
        fee: state.transactionFee,
        isReadyRegister: state.argument.account.isVerified,
        revokePreAddress: state.argument.account.method?.subValue,
      );

      information = await TransactionHelper.checkTransactionInfo(
        information.txHash,
        0,
        transactionUseCase: _transactionUseCase,
        config: config,
      );

      if (information.status == 0) {
        await _web3authUseCase.onLogout();

        await _accountUseCase.updateAccount(
          id: account.id,
          method: method,
          value: recoveryValue,
          subValue: recoveryAddress,
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
    } catch (e) {
      emit(
        state.copyWith(
          status: RecoveryMethodConfirmationStatus.onRecoverFail,
          error: e.toString(),
        ),
      );
    }
  }
}
