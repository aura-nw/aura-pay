import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'on_boarding_recover_sign_event.dart';
import 'on_boarding_recover_sign_state.dart';

final class OnBoardingRecoverSignBloc
    extends Bloc<OnBoardingRecoverSignEvent, OnBoardingRecoverSignState> {
  final Web3AuthUseCase _web3authUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final AuraAccountUseCase _accountUseCase;
  final AuthUseCase _authUseCase;

  OnBoardingRecoverSignBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._controllerKeyUseCase,
    this._web3authUseCase,
    this._accountUseCase,
    this._authUseCase, {
    required PyxisRecoveryAccount account,
    required GoogleAccount googleAccount,
  }) : super(
          OnBoardingRecoverSignState(
            account: account,
            googleAccount: googleAccount,
          ),
        ) {
    on(_onInit);
    on(_onChangeFee);
    on(_onConfirm);

    add(
      const OnBoardingRecoverSignEventOnInit(),
    );
  }

  final int _defaultGasLimit = 400000;
  final config = getIt.get<PyxisMobileConfig>();

  void _onInit(
    OnBoardingRecoverSignEventOnInit event,
    Emitter<OnBoardingRecoverSignState> emit,
  ) async {
    final config = getIt.get<PyxisMobileConfig>();
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
    OnBoardingRecoverSignEventOnChangeFee event,
    Emitter<OnBoardingRecoverSignState> emit,
  ) async {
    emit(
      state.copyWith(
        transactionFee: event.fee,
        status: OnBoardingRecoverSignStatus.none,
      ),
    );
  }

  void _onConfirm(
    OnBoardingRecoverSignEventOnConfirm event,
    Emitter<OnBoardingRecoverSignState> emit,
  ) async {
    emit(
      state.copyWith(
        status: OnBoardingRecoverSignStatus.onRecovering,
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
      );

      information = await TransactionHelper.checkTransactionInfo(
        information.txHash,
        0,
        smartAccountUseCase: _smartAccountUseCase,
      );

      if (information.status == 0) {
        final String? accessToken = await AuthHelper.getCurrentToken(
          authUseCase: _authUseCase,
          walletAddress: wallet.bech32Address,
        );

        await AuthHelper.removeCurrentToken(
          authUseCase: _authUseCase,
          walletAddress: wallet.bech32Address,
        );

        if (accessToken != null) {
          await _authUseCase.saveAccessToken(
            key: state.account.smartAccountAddress,
            accessToken: accessToken,
          );
        }

        final account = await _accountUseCase.saveAccount(
          address: state.account.smartAccountAddress,
          accountName: state.account.name ?? PyxisAccountConstant.unName,
          type: AuraAccountType.smartAccount,
        );

        await _accountUseCase.updateAccount(
          id: account.id,
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
            status: OnBoardingRecoverSignStatus.onRecoverSuccess,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: OnBoardingRecoverSignStatus.onRecoverFail,
            error: information.rawLog,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: OnBoardingRecoverSignStatus.onRecoverFail,
          error: e.toString(),
        ),
      );
    }
  }
}
