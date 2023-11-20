import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_smart_account/src/core/constants/aura_network_information.dart';
import 'package:aura_smart_account/src/core/definitions/grpc_client_channel.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    as aura;
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart';

import 'package:fixnum/fixnum.dart' as $fixnum;

import 'core/constants/smart_account_constant.dart';

/// [AuraSmartAccountImpl] class is implementation of [AuraSmartAccount]
class AuraSmartAccountImpl implements AuraSmartAccount {
  late aura.QueryClient querySmartAccountClient;
  late auth.QueryClient queryAuthClient;
  late tx.ServiceClient serviceClient;

  AuraSmartAccountImpl(AuraSmartAccountEnvironment environment) {
    _initClient(environment);
  }

  /// Create client
  void _initClient(AuraSmartAccountEnvironment environment) {
    GrpcClientChannel channel = AuraNetWorkInformation.serenityChannel;
    switch (environment) {
      case AuraSmartAccountEnvironment.serenity:
        channel = AuraNetWorkInformation.serenityChannel;
      case AuraSmartAccountEnvironment.euphoria:
        channel = AuraNetWorkInformation.euphoriaChannel;
      case AuraSmartAccountEnvironment.production:
        channel = AuraNetWorkInformation.productionChannel;
    }

    querySmartAccountClient = aura.QueryClient(
      channel.getChannel(),
    );
    queryAuthClient = auth.QueryClient(
      channel.getChannel(),
    );

    serviceClient = tx.ServiceClient(
      channel.getChannel(),
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
        ..typeUrl = pubKeyTypeUrl
        ..value = pubKey,
      salt: salt,
      initMsg: initMsgDefault,
      codeId: $fixnum.Int64(codeId),
    );

    // execute request.
    return querySmartAccountClient.generateAccount(request);
  }

  @override
  Future<MsgActivateAccountResponse> activeSmartAccount({
    required String walletAddress,
    required String smartAccountAddress,
    required List<int> initPubKey,
    List<int>? salt,
  }) async {
    // Create msg MsgActivateAccount.
    final aura.MsgActivateAccount msgActivateAccountRequest =
        aura.MsgActivateAccount(
      codeId: $fixnum.Int64(codeId),
      initMsg: initMsgDefault,
      accountAddress: smartAccountAddress,
      salt: salt,
      publicKey: Any.create()
        ..typeUrl = pubKeyTypeUrl
        ..value = initPubKey,
    );

    // Create query account request
    final auth.QueryAccountRequest queryAccountRequest =
        auth.QueryAccountRequest(
      address: walletAddress,
    );

    final auth.QueryAccountResponse account =
        await queryAuthClient.account(queryAccountRequest);

    // create account request with smart account address
    queryAccountRequest.clearAddress();
    queryAccountRequest.address = smartAccountAddress;

    // Get smart account
    final auth.QueryAccountResponse accountResponse =
        await queryAuthClient.account(queryAccountRequest);

    // create signer data
    final aura.SmartAccount smartAccount = aura.SmartAccount.create()
      ..address = accountResponse.account.value.toString();

    final Map<String, dynamic> singerData = {
      'chain_id': '',
      'accountNumber': smartAccount.accountNumber,
      'sequence': smartAccount.sequence,
    };

    // create broadcast tx request
    tx.BroadcastTxRequest broadcastTxRequest = tx.BroadcastTxRequest(
      mode: tx.BroadcastMode.BROADCAST_MODE_ASYNC,
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
