import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_smart_account/src/core/constants/aura_network_information.dart';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/core/definitions/aura_smart_account_error.dart';
import 'package:aura_smart_account/src/core/definitions/grpc_network_info.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    as aura;
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/base/v1beta1/coin.pb.dart';
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart' as pb;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:grpc/grpc.dart';

import 'core/constants/smart_account_constant.dart';
import 'core/helpers/aura_smart_account_helper.dart';
import 'core/helpers/wallet_helper.dart';

import 'dart:developer' as dev;

/// [AuraSmartAccountImpl] class is implementation of [AuraSmartAccount]
class AuraSmartAccountImpl implements AuraSmartAccount {
  late AuraNetworkInfo auraNetworkInfo;

  late aura.QueryClient querySmartAccountClient;
  late auth.QueryClient queryAuthClient;
  late tx.ServiceClient serviceClient;

  AuraSmartAccountImpl(AuraSmartAccountEnvironment environment) {
    _createClient(environment);
  }

  /// Create client
  void _createClient(AuraSmartAccountEnvironment environment) {
    auraNetworkInfo = AuraNetWorkInformationConstant.testChannel;
    switch (environment) {
      case AuraSmartAccountEnvironment.test:
        auraNetworkInfo = AuraNetWorkInformationConstant.testChannel;
      case AuraSmartAccountEnvironment.serenity:
        auraNetworkInfo = AuraNetWorkInformationConstant.serenityChannel;
      case AuraSmartAccountEnvironment.euphoria:
        auraNetworkInfo = AuraNetWorkInformationConstant.euphoriaChannel;
      case AuraSmartAccountEnvironment.production:
        auraNetworkInfo = AuraNetWorkInformationConstant.productionChannel;
    }

    querySmartAccountClient = aura.QueryClient(
      auraNetworkInfo.getChannel(),
    );
    queryAuthClient = auth.QueryClient(
      auraNetworkInfo.getChannel(),
    );

    serviceClient = tx.ServiceClient(
      auraNetworkInfo.getChannel(),
    );
  }

  @override
  Future<QueryGenerateAccountResponse> generateSmartAccount({
    required Uint8List pubKey,
    Uint8List? salt,
  }) async {
    try {
      // Generate a pub key from user pub key
      final Uint8List pubKeyGenerate =
          AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
              pubKey);

      // Create query account request.
      final aura.QueryGenerateAccountRequest request =
          aura.QueryGenerateAccountRequest(
        publicKey: pb.Any.create()
          ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl
          ..value = pubKeyGenerate,
        salt: salt,
        initMsg: AuraSmartAccountConstant.initMsgDefault,
        codeId: $fixnum.Int64(AuraSmartAccountConstant.codeId),
      );

      // execute request.
      return querySmartAccountClient.generateAccount(request);
    } catch (e) {
      if (e is GrpcError) {
        throw AuraSmartAccountError(
          code: e.code,
          errorMsg: e.message ?? e.codeName,
        );
      }
      throw AuraSmartAccountError(
        code: AuraSmartAccountConstant.errorCodeDefault,
        errorMsg: e.toString(),
      );
    }
  }

  @override
  Future<MsgActivateAccountResponse> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    required String fee,
    required int gasLimit,
  }) async {
    try {
      // Get pub key from private key
      final Uint8List pubKey = WalletHelper.getPublicKeyFromPrivateKey(
        userPrivateKey,
      );

      // Generate a pub key from user pub key
      final Uint8List pubKeyGenerate =
          AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
              pubKey);

      // Create msg MsgActivateAccount.
      final aura.MsgActivateAccount msgActivateAccountRequest =
          aura.MsgActivateAccount(
        codeId: $fixnum.Int64(AuraSmartAccountConstant.codeId),
        initMsg: AuraSmartAccountConstant.initMsgDefault,
        accountAddress: smartAccountAddress,
        salt: salt,
        publicKey: pb.Any.create()
          ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl
          ..value = pubKeyGenerate,
      );

      // Get account from smart account
      final Account accountResponse = await AuraSmartAccountHelper.getAccount(
        address: smartAccountAddress,
        queryClient: queryAuthClient,
      );

      // create signer data
      final aura.SmartAccount smartAccount = aura.SmartAccount.create()
        ..address = accountResponse.address()
        ..pubKey = accountResponse.pubKey()
        ..accountNumber = accountResponse.accountNumber()
        ..sequence = accountResponse.sequence();

      // Create fee
      final tx.Fee feeSign = tx.Fee.create()
        ..gasLimit = $fixnum.Int64(gasLimit)
        ..amount.add(
          Coin(
            denom: auraNetworkInfo.denom,
            amount: fee,
          ),
        );

      // Create tx
      final tx.Tx txSign = await AuraSmartAccountHelper.sign(
        privateKey: userPrivateKey,
        pubKey: pubKeyGenerate,
        messages: [
          pb.Any.pack(
            msgActivateAccountRequest,
            typeUrlPrefix: '',
          ),
        ],
        signerData: smartAccount,
        chainId: auraNetworkInfo.chainId,
        memo: memo,
        fee: feeSign,
      );

      // Create tx raw from tx sign
      tx.TxRaw txRaw = tx.TxRaw.create()
        ..bodyBytes = txSign.body.writeToBuffer()
        ..authInfoBytes = txSign.authInfo.writeToBuffer()
        ..signatures.addAll(txSign.signatures);

      final Uint8List txBytes = txRaw.writeToBuffer();

      // create broadcast tx request
      tx.BroadcastTxRequest broadcastTxRequest = tx.BroadcastTxRequest(
        mode: tx.BroadcastMode.BROADCAST_MODE_SYNC,
        txBytes: txBytes,
      );

      // Broadcast TxBytes
      final tx.BroadcastTxResponse broadcastTxResponse =
          await serviceClient.broadcastTx(broadcastTxRequest);

      dev.log('Response data = ${broadcastTxResponse.txResponse.data}');

      dev.log('Tx hash = ${broadcastTxResponse.txResponse.txhash}');

      final int statusCode = broadcastTxResponse.txResponse.code;

      if (statusCode == 0) {
        return aura.MsgActivateAccountResponse(
          address: smartAccountAddress,
        );
      }
      throw AuraSmartAccountError(
        code: AuraSmartAccountConstant.errorBroadcast,
        errorMsg: broadcastTxResponse.txResponse.rawLog,
      );
    } catch (e) {
      // Convert exception to Aura Smart Account Exception
      if (e is GrpcError) {
        throw AuraSmartAccountError(
          code: e.code,
          errorMsg: e.message ?? e.codeName,
        );
      }

      throw AuraSmartAccountError(
        code: AuraSmartAccountConstant.errorCodeDefault,
        errorMsg: e.toString(),
      );
    }
  }
}
