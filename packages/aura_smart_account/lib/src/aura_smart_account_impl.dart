import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_smart_account/src/core/constants/aura_network_information.dart';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/core/definitions/grpc_network_info.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    as aura;
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/base/v1beta1/coin.pb.dart';
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart';

import 'package:fixnum/fixnum.dart' as $fixnum;

import 'core/constants/smart_account_constant.dart';
import 'core/helpers/aura_smart_account_helper.dart';
import 'core/helpers/wallet_helper.dart';

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
    auraNetworkInfo = AuraNetWorkInformationConstant.serenityChannel;
    switch (environment) {
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
    required List<int> pubKey,
    List<int>? salt,
  }) async {
    // Create query account request.
    final aura.QueryGenerateAccountRequest request =
        aura.QueryGenerateAccountRequest(
      publicKey: Any.create()
        ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl
        ..value = pubKey,
      salt: salt,
      initMsg: AuraSmartAccountConstant.initMsgDefault,
      codeId: $fixnum.Int64(AuraSmartAccountConstant.codeId),
    );

    // execute request.
    return querySmartAccountClient.generateAccount(request);
  }

  @override
  Future<MsgActivateAccountResponse> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    List<int>? salt,
    String? memo,
    required String fee,
    required int gasLimit,
  }) async {
    final Uint8List pubKey = WalletHelper.getPublicKeyFromPrivateKey(
      userPrivateKey,
    );

    // Create msg MsgActivateAccount.
    final aura.MsgActivateAccount msgActivateAccountRequest =
        aura.MsgActivateAccount(
      codeId: $fixnum.Int64(AuraSmartAccountConstant.codeId),
      initMsg: AuraSmartAccountConstant.initMsgDefault,
      accountAddress: smartAccountAddress,
      salt: salt,
      publicKey: Any.create()
        ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl
        ..value = pubKey,
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
    final tx.Tx txSignBytes = await AuraSmartAccountHelper.sign(
      privateKey: userPrivateKey,
      queryClient: queryAuthClient,
      messages: [
        msgActivateAccountRequest as Any,
      ],
      signerData: smartAccount,
      chainId: auraNetworkInfo.chainId,
      bech32Hrp: auraNetworkInfo.bech32Hrp,
      memo: memo,
      fee: feeSign,
    );

    // create broadcast tx request
    tx.BroadcastTxRequest broadcastTxRequest = tx.BroadcastTxRequest(
      mode: tx.BroadcastMode.BROADCAST_MODE_ASYNC,
      txBytes: txSignBytes.writeToBuffer(),
    );

    // Broadcast TxBytes
    final tx.BroadcastTxResponse broadcastTxResponse =
        await serviceClient.broadcastTx(broadcastTxRequest);

    if (broadcastTxResponse.txResponse.code == 0) {
      return aura.MsgActivateAccountResponse(
        address: smartAccountAddress,
      );
    }

    throw broadcastTxResponse.txResponse.rawLog;
  }
}
