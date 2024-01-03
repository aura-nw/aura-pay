import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/core/helpers/device.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';

import 'signed_in_create_new_sm_account_pick_account_event.dart';
import 'signed_in_create_new_sm_account_pick_account_state.dart';

class SignedInCreateNewSmAccountPickAccountBloc extends Bloc<
    SignedInCreateNewSmAccountPickAccountEvent,
    SignedInCreateNewSmAccountPickAccountState> {
  final WalletUseCase _walletUseCase;
  final SmartAccountUseCase _smartAccountUseCase;
  final FeeGrantUseCase _feeGrantUseCase;
  final AuraAccountUseCase _accountUseCase;
  final ControllerKeyUseCase _controllerKeyUseCase;

  SignedInCreateNewSmAccountPickAccountBloc(
    this._walletUseCase,
    this._smartAccountUseCase,
    this._feeGrantUseCase,
    this._accountUseCase,
    this._controllerKeyUseCase,
  ) : super(
          const SignedInCreateNewSmAccountPickAccountState(),
        ) {
    on(_onChangeAccountName);
    on(_onCreate);
  }

  void _onCreate(
    SignedInCreateNewPickAccountOnSubmitEvent event,
    Emitter<SignedInCreateNewSmAccountPickAccountState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SignedInCreateNewPickAccountStatus.onLoading,
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

      final GrantFee? grantFee = await _grantFee(
        publicKey: wallet.publicKey,
        smartAccount: smartAccount,
      );

      if (grantFee != null) {
        emit(state.copyWith(
          status: SignedInCreateNewPickAccountStatus.onActiveSmartAccount,
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
            status: SignedInCreateNewPickAccountStatus.onActiveSmartAccountSuccess,
          ));
        } else {
          emit(
            state.copyWith(
              status: SignedInCreateNewPickAccountStatus.onCheckAddressError,
              errorMessage: transactionInformation.rawLog,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: SignedInCreateNewPickAccountStatus.onGrantFeeError,
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
          status: SignedInCreateNewPickAccountStatus.onCheckAddressError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onChangeAccountName(
    SignedInCreateNewPickAccountChangeEvent event,
    Emitter<SignedInCreateNewSmAccountPickAccountState> emit,
  ) {
    emit(
      state.copyWith(
        accountName: event.accountName,
        isReadySubmit: event.accountName.isNotEmpty,
      ),
    );
  }

  Future<GrantFee?> _grantFee({
    required Uint8List publicKey,
    required String smartAccount,
  }) async {
    try {
      /// call api grant fee for smart account
      final Uint8List smPubKey =
      AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
          publicKey);

      //0CE45424-BC2B-4E37-9766-E3B80C06B905
      final String deviceId = await DeviceHelper.getDeviceId();

      return _feeGrantUseCase.grantFee(
        pubKey: AuraSmartAccountHelper.encodeByte(smPubKey),
        deviceId: deviceId,
        smAddress: smartAccount,
      );
    } catch (e) {
      return null;
    }
  }
}
