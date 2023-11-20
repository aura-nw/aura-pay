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
    required String smartAccountAddress,
    required List<int> pubKey,
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
        ..value = pubKey,
    );

    // Create query account request
    final auth.QueryAccountRequest queryAccountRequest =
        auth.QueryAccountRequest(
      address: smartAccountAddress,
    );

    // Get account
    final auth.QueryAccountResponse accountResponse =
        await queryAuthClient.account(queryAccountRequest);

    // create smart account
    final aura.SmartAccount smartAccount = aura.SmartAccount.create();

    // create broadcast tx request
    tx.BroadcastTxRequest broadcastTxRequest = tx.BroadcastTxRequest();

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
