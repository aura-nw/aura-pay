import 'dart:convert';
import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/core/definitions/cosmos_signer_data.dart';
import 'package:aura_smart_account/src/core/definitions/grpc_network_info.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    as aura;
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/crypto/ed25519/export.dart'
    as ed25519;
import 'package:aura_smart_account/src/proto/cosmos/crypto/secp256k1/export.dart'
    as secp256k1;
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

import 'dart:developer' as dev;

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
        initMsg: AuraSmartAccountConstant.initMsgDefault(
          pluginManager: auraNetworkInfo.pluginManagerAddress,
        ),
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
    String? granter,
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
        initMsg: AuraSmartAccountConstant.initMsgDefault(
          pluginManager: auraNetworkInfo.pluginManagerAddress,
        ),
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

      if (granter != null) {
        feeSign.granter = granter;
      }

      // Broadcast TxBytes
      final tx.BroadcastTxResponse broadcastTxResponse =
          await _signAndBroadcastTx(
        userPrivateKey: userPrivateKey,
        pubKeyGenerate: pubKeyGenerate,
        msgs: [
          msgActivateAccountRequest,
        ],
        signerData: signerData,
        feeSign: feeSign,
        memo: memo,
      );

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
          msgs: [msgSend],
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
        msgs: [
          msgSend,
        ],
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
    final Account accountResponse = await _getAccountByAddress(
      address: smAccountAddress,
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
    required List<GeneratedMessage> msgs,
    required CosmosSignerData signerData,
    String? memo,
    required tx.Fee feeSign,
  }) async {
    // Create tx
    final tx.Tx txSign = await AuraSmartAccountHelper.sign(
      privateKey: userPrivateKey,
      pubKey: pubKeyGenerate,
      messages: msgs
          .map((msg) => pb.Any.pack(
                msg,
                typeUrlPrefix: '',
              ))
          .toList(),
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
  Future<int> simulateFee(
      {required Uint8List userPrivateKey,
      required String smartAccountAddress,
      required List<GeneratedMessage> msgs}) async {
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

      // Get signer data
      final CosmosSignerData signerData =
          await _getSignerData(smartAccountAddress);

      // Get tx sign
      final tx.Tx txSign = await AuraSmartAccountHelper.sign(
        privateKey: userPrivateKey,
        pubKey: pubKeyGenerate,
        messages: msgs
            .map((e) => pb.Any.pack(
                  e,
                  typeUrlPrefix: '',
                ))
            .toList(),
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
  Future<TxResponse> setRecoveryMethod({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String recoverAddress,
    AuraSmartAccountFee? fee,
    bool isReadyRegister = false,
    String? revokePreAddress,
    String ?memo,
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

      // Create messages to broadcast
      List<GeneratedMessage> messages =
          AuraSmartAccountHelper.createSetRecoveryMethodMsg(
        smartAccountAddress: smartAccountAddress,
        recoverAddress: recoverAddress,
        denom: auraNetworkInfo.denom,
        recoverContractAddress: auraNetworkInfo.recoverContractAddress,
        isReadyRegister: isReadyRegister,
        revokePreAddress: revokePreAddress,
      );

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

      // Get signer data
      CosmosSignerData signerData = await _getSignerData(smartAccountAddress);

      // Broadcast TxBytes
      final tx.BroadcastTxResponse broadcastTxResponse =
          await _signAndBroadcastTx(
        userPrivateKey: userPrivateKey,
        pubKeyGenerate: pubKeyGenerate,
        msgs: messages,
        signerData: signerData,
        feeSign: feeSign,
        memo: memo,
      );

      final int statusCode = broadcastTxResponse.txResponse.code;

      if (statusCode == 0) {
        return broadcastTxResponse.txResponse;
      }
      throw AuraSmartAccountError(
        code: SmartAccountErrorCode.errorBroadcast,
        errorMsg: broadcastTxResponse.txResponse.rawLog,
      );
    } catch (e) {
      // handle exception
      throw _getError(e);
    }
  }

  @override
  Future<TxResponse> recoverSmartAccount({
    required Uint8List privateKey,
    required String recoveryAddress,
    required String smartAccountAddress,
    AuraSmartAccountFee? fee,
    String ?memo,
  }) async {
    try {
      // Get pub key from private key
      final Uint8List pubKey = WalletHelper.getPublicKeyFromPrivateKey(
        privateKey,
      );

      // Generate a pub key from user pub key
      final Uint8List pubKeyGenerate =
          AuraSmartAccountHelper.generateSmartAccountPubKeyFromUserPubKey(
        pubKey,
      );

      final List<GeneratedMessage> messages = List.empty(growable: true);

      // Create new pub key
      final pb.Any newPubKey = pb.Any.create()
        ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl
        ..value = pubKeyGenerate;

      // Create msg recovery
      final aura.MsgRecover msgRecover = aura.MsgRecover.create()
        ..address = smartAccountAddress
        ..creator = recoveryAddress
        ..publicKey = newPubKey
        ..credentials = '';

      messages.add(msgRecover);

      // Get signer data
      final CosmosSignerData signerData = await _getSignerData(recoveryAddress);

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

      feeSign.granter = smartAccountAddress;

      // broadcast tx
      final tx.BroadcastTxResponse broadcastTxResponse =
          await _signAndBroadcastTx(
        userPrivateKey: privateKey,
        feeSign: feeSign,
        msgs: messages,
        pubKeyGenerate: pubKeyGenerate,
        signerData: signerData,
        memo: memo,
      );

      final int statusCode = broadcastTxResponse.txResponse.code;

      // return response or error
      if (statusCode == 0) {
        return broadcastTxResponse.txResponse;
      }
      throw AuraSmartAccountError(
        code: SmartAccountErrorCode.errorBroadcast,
        errorMsg: broadcastTxResponse.txResponse.rawLog,
      );
    } catch (e) {
      // Handle error
      throw _getError(e);
    }
  }

  @override
  Future<String> getCosmosPubKeyByAddress({required String address}) async {
    final Account accountResponse = await _getAccountByAddress(
      address: address,
    );

    final pb.Any pubKeyAny = accountResponse.pubKey();

    switch (pubKeyAny.typeUrl) {
      case '/cosmos.crypto.secp256k1.PubKey':
        secp256k1.PubKey pubKey = secp256k1.PubKey.fromBuffer(pubKeyAny.value);

        return base64Encode(pubKey.key);
      case '/cosmos.crypto.ed25519.PubKey':
        ed25519.PubKey pubKey = ed25519.PubKey.fromBuffer(pubKeyAny.value);
        return base64Encode(pubKey.key);
      default:
        throw AuraSmartAccountError(
          code: SmartAccountErrorCode.errorUnSupportPubKeyType,
          errorMsg: 'Pubkey type URL ${pubKeyAny.typeUrl} not recognized',
        );
    }
  }

  Future<Account> _getAccountByAddress({
    required String address,
  }) async {
    // Create ath account request
    final auth.QueryAccountRequest queryAccountRequest =
        auth.QueryAccountRequest(
      address: address,
    );

    // Get account
    final auth.QueryAccountResponse response =
        await queryAuthClient.account(queryAccountRequest);

    final Account accountResponse =
        await AuraSmartAccountHelper.deserializerAccounts(
      response: response,
    );

    return accountResponse;
  }
}
