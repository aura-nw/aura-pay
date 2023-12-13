import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/core/definitions/cosmos_signer_data.dart';
import 'package:aura_smart_account/src/core/definitions/grpc_network_info.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    as aura;
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/bank/v1beta1/export.dart'
    as bank;
import 'package:aura_smart_account/src/proto/cosmos/base/v1beta1/export.dart'
    as base;
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart' as pb;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';

import 'core/constants/smart_account_constant.dart';
import 'core/constants/smart_account_error_code.dart';
import 'core/helpers/aura_smart_account_helper.dart';
import 'core/helpers/wallet_helper.dart';

import 'dart:developer' as dev;

import 'proto/cosmos/base/query/v1beta1/export.dart';

/// [AuraSmartAccountImpl] class is implementation of [AuraSmartAccount]
class AuraSmartAccountImpl implements AuraSmartAccount {
  final AuraSmartAccountEnvironment environment;
  late AuraNetworkInfo auraNetworkInfo;

  late aura.QueryClient querySmartAccountClient;
  late auth.QueryClient queryAuthClient;
  late bank.QueryClient bankClient;
  late tx.ServiceClient serviceClient;

  AuraSmartAccountImpl(this.environment) {
    _createClient(environment);
  }

  /// Create client
  void _createClient(AuraSmartAccountEnvironment environment) {
    auraNetworkInfo = AuraSmartAccountHelper.getNetworkInfoFromEnvironment(
      environment,
    );

    AuraSmartAccountCache.init(
      auraNetworkInfo.denom,
      auraNetworkInfo.chainId,
    );

    querySmartAccountClient = aura.QueryClient(
      auraNetworkInfo.getChannel(),
    );
    queryAuthClient = auth.QueryClient(
      auraNetworkInfo.getChannel(),
    );

    bankClient = bank.QueryClient(
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
        codeId: $fixnum.Int64(
          auraNetworkInfo.codeId,
        ),
      );

      // execute request.
      return querySmartAccountClient.generateAccount(request);
    } catch (e) {
      // Handle exception
      throw _getError(e);
    }
  }

  @override
  Future<TxResponse> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    AuraSmartAccountFee? fee,
  }) async {
    try {
      // Get pub key from private key
      final Uint8List pubKey = WalletHelper.getPublicKeyFromPrivateKey(
        userPrivateKey,
      );

      // Generate a pub key from user pub key
      final Uint8List pubKeyGenerate =
          AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
        pubKey,
      );

      // Create msg MsgActivateAccount.
      final aura.MsgActivateAccount msgActivateAccountRequest =
          aura.MsgActivateAccount(
        codeId: $fixnum.Int64(
          auraNetworkInfo.codeId,
        ),
        initMsg: AuraSmartAccountConstant.initMsgDefault,
        accountAddress: smartAccountAddress,
        salt: salt,
        publicKey: pb.Any.create()
          ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl
          ..value = pubKeyGenerate,
      );

      // Get signer data
      final CosmosSignerData signerData =
          await _getSignerData(smartAccountAddress);

      // Create fee
      late tx.Fee feeSign;

      if (fee == null) {
        feeSign = CosmosHelper.calculateFee(
          AuraSmartAccountConstant.defaultGasActiveSmartAccount,
          deNom: auraNetworkInfo.denom,
        );
      } else {
        // Create fee
        feeSign = tx.Fee.create()
          ..gasLimit = $fixnum.Int64(fee.gasLimit)
          ..amount.add(
            base.Coin(
              denom: auraNetworkInfo.denom,
              amount: fee.fee,
            ),
          );
      }

      // Broadcast TxBytes
      final tx.BroadcastTxResponse broadcastTxResponse =
          await _signAndBroadcastTx(
        userPrivateKey: userPrivateKey,
        pubKeyGenerate: pubKeyGenerate,
        msg: msgActivateAccountRequest,
        signerData: signerData,
        feeSign: feeSign,
        memo: memo,
      );

      dev.log('Response data = ${broadcastTxResponse.txResponse.data}');

      dev.log('Tx hash = ${broadcastTxResponse.txResponse.txhash}');

      final int statusCode = broadcastTxResponse.txResponse.code;

      if (statusCode == 0) {
        return broadcastTxResponse.txResponse;
      }
      throw AuraSmartAccountError(
        code: SmartAccountErrorCode.errorBroadcast,
        errorMsg: broadcastTxResponse.txResponse.rawLog,
      );
    } catch (e) {
      // Handle exception
      throw _getError(e);
    }
  }

  @override
  Future<TxResponse> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    AuraSmartAccountFee? fee,
    String? memo,
  }) async {
    try {
      // Get pub key from private key
      final Uint8List pubKey = WalletHelper.getPublicKeyFromPrivateKey(
        userPrivateKey,
      );

      // Generate a pub key from user pub key
      final Uint8List pubKeyGenerate =
          AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
        pubKey,
      );

      // Create coin
      final base.Coin coin = base.Coin.create()
        ..denom = auraNetworkInfo.denom
        ..amount = amount;

      // Create msg send
      final bank.MsgSend msgSend = bank.MsgSend.create()
        ..fromAddress = smartAccountAddress
        ..toAddress = receiverAddress
        ..amount.add(coin);

      // Get signer data
      final CosmosSignerData signerData =
          await _getSignerData(smartAccountAddress);

      // Create fee
      late tx.Fee feeSign;

      if (fee == null) {
        final int gasEstimation = await simulateFee(
          userPrivateKey: userPrivateKey,
          smartAccountAddress: smartAccountAddress,
          receiverAddress: receiverAddress,
          amount: amount,
          memo: memo,
        );

        feeSign = CosmosHelper.calculateFee(
          gasEstimation,
          deNom: auraNetworkInfo.denom,
        );
      } else {
        // Create fee
        feeSign = tx.Fee.create()
          ..gasLimit = $fixnum.Int64(fee.gasLimit)
          ..amount.add(
            base.Coin(
              denom: auraNetworkInfo.denom,
              amount: fee.fee,
            ),
          );
      }

      final tx.BroadcastTxResponse broadcastTxResponse =
          await _signAndBroadcastTx(
        userPrivateKey: userPrivateKey,
        feeSign: feeSign,
        msg: msgSend,
        pubKeyGenerate: pubKeyGenerate,
        signerData: signerData,
        memo: memo,
      );

      // Get status code
      final int statusCode = broadcastTxResponse.txResponse.code;

      // Broadcast successfully
      if (statusCode == 0) {
        return broadcastTxResponse.txResponse;
      }

      throw AuraSmartAccountError(
        code: SmartAccountErrorCode.errorBroadcast,
        errorMsg: broadcastTxResponse.txResponse.rawLog,
      );
    } catch (e) {
      // Handle exception
      throw _getError(e);
    }
  }

  // Convert exception to Aura Smart Account Exception
  AuraSmartAccountError _getError(Object e) {
    if (e is AuraSmartAccountError) {
      return e;
    }

    if (e is GrpcError) {
      return AuraSmartAccountError(
        code: e.code,
        errorMsg: e.message ?? e.codeName,
      );
    }

    return AuraSmartAccountError(
      code: SmartAccountErrorCode.errorCodeDefault,
      errorMsg: e.toString(),
    );
  }

  // Get signer data from sm account address
  Future<CosmosSignerData> _getSignerData(String smAccountAddress) async {
    // Get account from smart account
    final Account accountResponse = await AuraSmartAccountHelper.getAccount(
      address: smAccountAddress,
      queryClient: queryAuthClient,
    );

    // create signer data
    final CosmosSignerData signerData = CosmosSignerData(
      chainId: auraNetworkInfo.chainId,
      sequence: accountResponse.sequence(),
      accountNumber: accountResponse.accountNumber(),
    );

    return signerData;
  }

  // Sign and broadcast tx
  Future<tx.BroadcastTxResponse> _signAndBroadcastTx({
    required Uint8List userPrivateKey,
    required Uint8List pubKeyGenerate,
    required GeneratedMessage msg,
    required CosmosSignerData signerData,
    String? memo,
    required tx.Fee feeSign,
  }) async {
    // Create tx
    final tx.Tx txSign = await AuraSmartAccountHelper.sign(
      privateKey: userPrivateKey,
      pubKey: pubKeyGenerate,
      messages: [
        pb.Any.pack(
          msg,
          typeUrlPrefix: '',
        ),
      ],
      signerData: signerData,
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

    return broadcastTxResponse;
  }

  @override
  Future<String> getToken({
    required String address,
  }) async {
    try {
      // Create query balance request
      bank.QueryBalanceRequest balanceRequest =
          bank.QueryBalanceRequest.create()
            ..address = address
            ..denom = auraNetworkInfo.denom;

      // query balance
      final bank.QueryBalanceResponse balanceResponse =
          await bankClient.balance(balanceRequest);

      return balanceResponse.balance.amount;
    } catch (e) {
      // handle error
      throw _getError(e);
    }
  }

  @override
  Future<int> simulateFee({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    String? memo,
  }) async {
    try {
      // Get pub key from private key
      final Uint8List pubKey = WalletHelper.getPublicKeyFromPrivateKey(
        userPrivateKey,
      );

      // Generate a pub key from user pub key
      final Uint8List pubKeyGenerate =
          AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
        pubKey,
      );

      // Create coin
      final base.Coin coin = base.Coin.create()
        ..denom = auraNetworkInfo.denom
        ..amount = amount;

      // Create msg send
      final bank.MsgSend msgSend = bank.MsgSend.create()
        ..fromAddress = smartAccountAddress
        ..toAddress = receiverAddress
        ..amount.add(coin);

      // Get signer data
      final CosmosSignerData signerData =
          await _getSignerData(smartAccountAddress);

      // Get tx sign
      final tx.Tx txSign = await AuraSmartAccountHelper.sign(
        privateKey: userPrivateKey,
        pubKey: pubKeyGenerate,
        messages: [
          pb.Any.pack(
            msgSend,
            typeUrlPrefix: '',
          ),
        ],
        signerData: signerData,
        fee: tx.Fee.create(),
      );

      // create simulate request
      final tx.SimulateRequest simulateRequest = tx.SimulateRequest.create()
        ..txBytes = txSign.writeToBuffer();

      final tx.SimulateResponse response =
          await serviceClient.simulate(simulateRequest);

      return response.gasInfo.gasUsed.toInt();
    } catch (e) {
      dev.log(e.toString());
      // Default gas estimation
      return 100000;
    }
  }

  @override
  Future<TxResponse> getTx({required String txHash}) async {
    try {
      // Create request
      final tx.GetTxRequest request = tx.GetTxRequest(
        hash: txHash,
      );

      // execute request
      final tx.GetTxResponse response = await serviceClient.getTx(
        request,
      );

      return response.txResponse;
    } catch (e) {
      // Handle exception
      throw _getError(e);
    }
  }

  @override
  Future<List<AuraSmartAccountTransaction>> getHistoryTransaction({
    required List<String> events,
    OrderParameter orderParameter = const OrderParameter(),
  }) async {
    try {
      // Create request
      final tx.GetTxsEventRequest request = tx.GetTxsEventRequest(
        events: events,
        pagination: PageRequest(
          offset: $fixnum.Int64(orderParameter.offset),
          limit: $fixnum.Int64(orderParameter.limit),
        ),
        orderBy: orderParameter.getOrderBy,
      );

      // Get response from request
      final tx.GetTxsEventResponse response =
          await serviceClient.getTxsEvent(request);

      // Map response to List<AuraSmartAccountTransaction>
      return response.txResponses.map((e) {
        int index = response.txResponses.indexOf(e);

        final txs = response.txs[index];

        final msg = txs.body.messages[0];

        bank.MsgSend msgSend = bank.MsgSend.create();

        if(msg.canUnpackInto(msgSend)){
          msgSend = msg.unpackInto(msgSend);
        }

        String ? amount;

        if(msgSend.amount.isNotEmpty){
          amount = msgSend.amount[0].amount;
        }

        // Get fee
        final String fee = txs.authInfo.fee.amount[0].amount;

        final String memo = txs.body.memo;

        final String type = msg.typeUrl;
        return AuraSmartAccountTransaction(
          type: type,
          status: e.code,
          txHash: e.txhash,
          timeStamp: e.timestamp,
          fee: fee,
          memo: memo,
          amount: amount,
          events: [
            msgSend.fromAddress,
            msgSend.toAddress,
          ],
        );
      }).toList();
    } catch (e) {
      throw _getError(e);
    }
  }

  Future<void> recoverSmartAccount({
    required String smartAccountAddress,
    required Uint8List newPrivateKey,
  }) async {
    try {
      pb.Any pubKeyAny = pb.Any.create()
        ..value = []
        ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl;

      final aura.MsgRecover request = aura.MsgRecover.create()
        ..creator = smartAccountAddress
        ..address = smartAccountAddress
        ..publicKey = pubKeyAny
        ..credentials = '';
    } catch (e) {
      throw _getError(e);
    }
  }
}
