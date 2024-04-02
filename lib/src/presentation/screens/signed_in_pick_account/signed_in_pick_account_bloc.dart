import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:developer' as dev;

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/helpers/authentication_helper.dart';
import 'package:pyxis_mobile/src/core/helpers/device.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';

import 'signed_in_pick_account_event.dart';
import 'signed_in_pick_account_state.dart';

class SignedInPickAccountBloc
    extends Bloc<SignedInPickAccountEvent, SignedInPickAccountState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final FeeGrantUseCase _feeGrantUseCase;
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;
  final DeviceManagementUseCase _deviceManagementUseCase;
  final AuthUseCase _authUseCase;

  SignedInPickAccountBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._feeGrantUseCase,
    this._accountUseCase,
    this._controllerKeyUseCase,
    this._deviceManagementUseCase,
    this._authUseCase,
  ) : super(
          const SignedInPickAccountState(),
        ) {
    on(_onChangeAccountName);
    on(_onCreate);
  }

  void _onCreate(
    SignedInPickAccountOnSubmitEvent event,
    Emitter<SignedInPickAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SignedInPickAccountStatus.onLoading,
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

      /// call api grant fee for smart account
      final Uint8List smPubKey =
          AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
        wallet.publicKey,
      );

      /// Get device id
      final String deviceId = await DeviceHelper.getDeviceId();

      /// Register device or sign in by device
      // final String accessToken = await AuthHelper.registerOrSignIn(
      //   deviceManagementUseCase: _deviceManagementUseCase,
      //   authUseCase: _authUseCase,
      //   privateKey: AuraWalletHelper.getPrivateKeyFromString(
      //     wallet.privateKey!,
      //   ),
      // );
      //
      // /// Save token by smart account address
      // await AuthHelper.saveTokenByWalletAddress(
      //   authUseCase: _authUseCase,
      //   walletAddress: smartAccount,
      //   accessToken: accessToken,
      // );

      /// Check device fee grant
      final GrantFee? grantFee = await _grantFee(
        smPubKey: smPubKey,
        smartAccount: smartAccount,
        deviceId: deviceId,
      );

      if (grantFee != null) {
        emit(state.copyWith(
          status: SignedInPickAccountStatus.onActiveSmartAccount,
        ));

        TransactionInformation transactionInformation =
            await _smartAccountUseCase.activeSmartAccount(
          userPrivateKey: AuraWalletHelper.getPrivateKeyFromString(
            wallet.privateKey!,
          ),
          smartAccountAddress: smartAccount,
          salt: saltBytes,
          memo: 'Active smart account',
          granter: grantFee.granter,
        );

        transactionInformation = await TransactionHelper.checkTransactionInfo(
          transactionInformation.txHash,
          0,
          smartAccountUseCase: _smartAccountUseCase,
        );

        if (transactionInformation.status == 0) {
          await _accountUseCase.saveAccount(
            address: smartAccount,
            accountName: state.accountName,
            type: AuraAccountType.smartAccount,
          );

          await _controllerKeyUseCase.saveKey(
            address: smartAccount,
            key: wallet.privateKey!,
          );

          emit(state.copyWith(
            status: SignedInPickAccountStatus.onActiveSmartAccountSuccess,
          ));
        } else {
          emit(
            state.copyWith(
              status: SignedInPickAccountStatus.onCheckAddressError,
              errorMessage: transactionInformation.rawLog,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: SignedInPickAccountStatus.onGrantFeeError,
            smartAccountAddress: smartAccount,
            userPrivateKey: AuraWalletHelper.getPrivateKeyFromString(
              wallet.privateKey!,
            ),
            saltBytes: saltBytes,
          ),
        );
      }
    } catch (e, s) {
      emit(
        state.copyWith(
          status: SignedInPickAccountStatus.onCheckAddressError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<GrantFee?> _grantFee({
    required Uint8List smPubKey,
    required String smartAccount,
    required String deviceId,
  }) async {
    try {
      return _feeGrantUseCase.grantFee(
        pubKey: AuraSmartAccountHelper.encodeByte(smPubKey),
        deviceId: deviceId,
        smAddress: smartAccount,
        tokenKey: AuthHelper.createAccessTokenKey(
          walletAddress: smartAccount,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  void _onChangeAccountName(
    SignedInPickAccountOnPickAccountChangeEvent event,
    Emitter<SignedInPickAccountState> emit,
  ) {
    emit(
      state.copyWith(
        accountName: event.accountName,
        isReadySubmit: event.accountName.isNotEmpty,
      ),
    );
  }
}
