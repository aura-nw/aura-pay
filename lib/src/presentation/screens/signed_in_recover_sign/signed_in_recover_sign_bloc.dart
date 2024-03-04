import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';

import 'signed_in_recover_sign_event.dart';
import 'signed_in_recover_sign_state.dart';

final class SignedInRecoverSignBloc
    extends Bloc<SignedInRecoverSignEvent, SignedInRecoverSignState> {
  final Web3AuthUseCase _web3authUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;
  final AuthUseCase _authUseCase;

  SignedInRecoverSignBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._web3authUseCase,
    this._accountUseCase,
    this._authUseCase, {
    required PyxisRecoveryAccount account,
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
    on(_onChangeMemo);
    on(_onChangeShowFullMsg);

    add(
      const SignedInRecoverSignEventOnInit(),
    );
  }

  void _onChangeMemo(
    SignedInRecoverSignEventOnChangeMemo event,
    Emitter<SignedInRecoverSignState> emit,
  ) {
    emit(
      state.copyWith(
        memo: event.memo,
        status: SignedInRecoverSignStatus.none,
      ),
    );
  }

  void _onChangeShowFullMsg(
    SignedInRecoverSignEventOnChangeShowFullMsg event,
    Emitter<SignedInRecoverSignState> emit,
  ) {
    emit(
      state.copyWith(
        isShowFullMsg: !state.isShowFullMsg,
        status: SignedInRecoverSignStatus.none,
      ),
    );
  }

  final int _defaultGasLimit = 400000;

  void _onInit(
    SignedInRecoverSignEventOnInit event,
    Emitter<SignedInRecoverSignState> emit,
  ) async {
    final config = getIt.get<PyxisMobileConfig>();

    final String backupPrivateKey = await _web3authUseCase.getPrivateKey();

    final wallet = await _walletUseCase.importWallet(
      privateKeyOrPassPhrase: backupPrivateKey,
    );

    final msg = AuraSmartAccountHelper.createRecoveryMsg(
      privateKey: AuraWalletHelper.getPrivateKeyFromString(
        backupPrivateKey,
      ),
      recoveryAddress: wallet.bech32Address,
      smartAccountAddress: state.account.smartAccountAddress,
    );
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
        msgRecover: msg,
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
        smartAccountAddress: state.account.smartAccountAddress,
        memo: state.memo,
      );

      information = await TransactionHelper.checkTransactionInfo(
        information.txHash,
        0,
        smartAccountUseCase: _smartAccountUseCase,
      );

      if (information.status == 0) {
        // final String? accessToken = await AuthHelper.getCurrentToken(
        //   authUseCase: _authUseCase,
        //   walletAddress: wallet.bech32Address,
        // );
        //
        // await AuthHelper.removeCurrentToken(
        //   authUseCase: _authUseCase,
        //   walletAddress: wallet.bech32Address,
        // );
        //
        // if (accessToken != null) {
        //   await _authUseCase.saveAccessToken(
        //     key: state.account.smartAccountAddress,
        //     accessToken: accessToken,
        //   );
        // }

        AuraAccount? localAccount = await _accountUseCase.getAccountByAddress(
          address: state.account.smartAccountAddress,
        );

        localAccount ??= await _accountUseCase.saveAccount(
          address: state.account.smartAccountAddress,
          type: AuraAccountType.smartAccount,
          accountName: state.account.name ?? PyxisAccountConstant.unName,
        );

        await _accountUseCase.updateAccount(
          id: localAccount.id,
          method: AuraSmartAccountRecoveryMethod.web3Auth,
          value: state.googleAccount.email,
          subValue: wallet.bech32Address,
        );

        await _controllerKeyUseCase.saveKey(
          address: state.account.smartAccountAddress,
          key: backupPrivateKey,
        );

        await _web3authUseCase.onLogout();

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
}
