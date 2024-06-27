import 'dart:typed_data';
import 'package:aura_smart_account/src/core/constants/aura_network_information.dart';
import 'package:aura_smart_account/src/core/constants/smart_account_constant.dart';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/core/definitions/aura_smart_account_environment.dart';
import 'package:aura_smart_account/src/core/definitions/cosmos_signer_data.dart';
import 'package:aura_smart_account/src/core/definitions/grpc_network_info.dart';
import 'package:aura_smart_account/src/core/utils/string_validator.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    as aura;
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/feegrant/v1beta1/export.dart'
    as feeGrant;
import 'package:aura_smart_account/src/proto/cosmos/tx/signing/v1beta1/export.dart'
    as signing;
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/cosmwasm/wasm/v1/export.dart'
    as wasm;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart' as pb;
import 'package:aura_smart_account/src/proto/cosmos/crypto/secp256k1/export.dart'
    as secp256;
import 'package:aura_smart_account/src/proto/cosmos/base/v1beta1/export.dart'
    as base;
import 'package:hex/hex.dart';
import 'package:protobuf/protobuf.dart' as protobuf;
import 'wallet_helper.dart';

typedef AccountDeserializer = Account Function(pb.Any);

sealed class AuraSmartAccountHelper {
  static AuraNetworkInfo getNetworkInfoFromEnvironment(
      AuraSmartAccountEnvironment environment) {
    switch (environment) {
      case AuraSmartAccountEnvironment.test:
        return AuraNetWorkInformationConstant.testChannel;
      case AuraSmartAccountEnvironment.serenity:
        return AuraNetWorkInformationConstant.serenityChannel;
      case AuraSmartAccountEnvironment.euphoria:
        return AuraNetWorkInformationConstant.euphoriaChannel;
      case AuraSmartAccountEnvironment.production:
        return AuraNetWorkInformationConstant.productionChannel;
    }
  }

  static final Map<String, AccountDeserializer> _deserializerAccounts = {
    'BaseAccount': BaseAccount.fromAny,
    'SmartAccount': BaseAccount.fromAny,
    'ModuleAccount': ModuleAccount.fromAny,
    'BaseVestingAccount': BaseVestingAccount.fromAny,
    'DelayedVestingAccount': DelayedVestingAccount.fromAny,
    'ContinuousVestingAccount': ContinuousVestingAccount.fromAny,
    'PeriodicVestingAccount': PeriodicVestingAccount.fromAny,
  };

  static Future<tx.Tx> sign({
    required Uint8List privateKey,
    required Uint8List pubKey,
    required List<pb.Any> messages,
    required CosmosSignerData signerData,
    required tx.Fee fee,
    String? memo,
  }) async {
    // Create pub key
    pb.Any pubKeyAny = pb.Any.create()
      ..value = pubKey
      ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl;

    // Create txBody
    final tx.TxBody txBody = tx.TxBody(
      memo: memo,
      messages: messages,
    );

    // Get tx Body Bytes
    final Uint8List txBodyBytes = txBody.writeToBuffer();

    // Create auth Info
    final tx.AuthInfo authInfo = tx.AuthInfo(
      fee: fee,
      signerInfos: [
        tx.SignerInfo(
          publicKey: pubKeyAny,
          sequence: signerData.sequence,
          modeInfo: tx.ModeInfo(
            single: tx.ModeInfo_Single(
              mode: signing.SignMode.SIGN_MODE_DIRECT,
            ),
          ),
        ),
      ],
    );

    // Get auth body bytes
    final Uint8List authInfoBytes = authInfo.writeToBuffer();

    // Create sign doc
    final tx.SignDoc signDoc = tx.SignDoc(
      bodyBytes: txBodyBytes,
      authInfoBytes: authInfoBytes,
      accountNumber: signerData.accountNumber,
      chainId: signerData.chainId,
    );

    // Get sign doc bytes
    final Uint8List makeSignDocToBytes = signDoc.writeToBuffer();

    // Create signature
    final Uint8List signature = WalletHelper.createSignature(
      Uint8List.fromList(makeSignDocToBytes),
      privateKey,
    );

    // Create tx
    final tx.Tx txSign = tx.Tx(
      signatures: [
        signature,
      ],
      body: txBody,
      authInfo: authInfo,
    );

    return txSign;
  }

  static Future<Account> deserializerAccounts({
    required auth.QueryAccountResponse response,
  }) async {
    // Get Account from key
    final String key = _deserializerAccounts.keys
        .singleWhere((element) => response.account.typeUrl.contains(element));

    return _deserializerAccounts[key]!.call(response.account);
  }

  /// Add prefix to user pub key
  /// It return a smart account pub key;
  /// See more at here [https://github.com/aura-nw/pyxis-smart-account/blob/main/ts/sdk/scripts/deploy.js#L143-L149]
  static Uint8List generateSmartAccountPubKeyFromUserPubKey(Uint8List pubKey) {
    secp256.PubKey secp256PubKey = secp256.PubKey.create()..key = pubKey;

    final Uint8List pubKeyGenerate = Uint8List.fromList(
      secp256PubKey.writeToBuffer(),
    );

    return pubKeyGenerate;
  }

  static String encodeByte(Uint8List bytes) {
    return HEX.encode(bytes);
  }

  static List<protobuf.GeneratedMessage> createSetRecoveryMethodMsg({
    required String smartAccountAddress,
    required String recoverAddress,
    bool isReadyRegister = false,
    String? revokePreAddress,
    required String denom,
    required String recoverContractAddress,
  }) {
    final List<protobuf.GeneratedMessage> messages = List.empty(growable: true);

    // Create revoke fee grant if need
    if (isReadyRegister) {
      feeGrant.MsgRevokeAllowance revokeAllowance =
          feeGrant.MsgRevokeAllowance.create()
            ..granter = smartAccountAddress
            ..grantee = revokePreAddress ?? '';

      // Create msg unregister contract
      final wasm.MsgExecuteContract msgUnRegister =
          wasm.MsgExecuteContract.create()
            ..sender = smartAccountAddress
            ..contract = smartAccountAddress
            ..msg = AuraSmartAccountConstant.unRegisterRecovery(
              recoveryContractAddress: recoverContractAddress,
            );

      messages.addAll([
        revokeAllowance,
        msgUnRegister,
      ]);
    }

    // Create grant fee for recover address

    feeGrant.BasicAllowance basicAllowance = feeGrant.BasicAllowance.create()
      ..spendLimit.add(
        base.Coin.create()
          ..denom = denom
          ..amount = AuraSmartAccountConstant.maxFeeGrant,
      );

    feeGrant.AllowedMsgAllowance allowance =
        feeGrant.AllowedMsgAllowance.create()
          ..allowance = pb.Any.pack(
            basicAllowance,
            typeUrlPrefix: '',
          )
          ..allowedMessages.add(
            AuraSmartAccountConstant.msgRecoverTypeUrl,
          );

    // Create fee grant
    feeGrant.MsgGrantAllowance msgGrant = feeGrant.MsgGrantAllowance.create()
      ..granter = smartAccountAddress
      ..grantee = recoverAddress
      ..allowance = pb.Any.pack(
        allowance,
        typeUrlPrefix: '',
      );

    // Create msg execute
    wasm.MsgExecuteContract msgExecuteContract =
        wasm.MsgExecuteContract.create()
          ..sender = smartAccountAddress
          ..contract = smartAccountAddress
          ..msg = AuraSmartAccountConstant.setRecoveryMsg(
            smartAccountAddress: smartAccountAddress,
            recoverAddress: recoverAddress,
            recoveryContractAddress: recoverContractAddress,
          );

    // Add message to sign
    messages.addAll([msgExecuteContract, msgGrant]);

    return messages;
  }

  static aura.MsgRecover createRecoveryMsg({
    required Uint8List privateKey,
    required String recoveryAddress,
    required String smartAccountAddress,
  }) {
    // Get pub key from private key
    final Uint8List pubKey = WalletHelper.getPublicKeyFromPrivateKey(
      privateKey,
    );

    // Generate a pub key from user pub key
    final Uint8List pubKeyGenerate = generateSmartAccountPubKeyFromUserPubKey(
      pubKey,
    );

    // Create new pub key
    final pb.Any newPubKey = pb.Any.create()
      ..typeUrl = AuraSmartAccountConstant.pubKeyTypeUrl
      ..value = pubKeyGenerate;
    return aura.MsgRecover()
      ..address = smartAccountAddress
      ..creator = recoveryAddress
      ..publicKey = newPubKey
      ..credentials = '';
  }

  static Map<String, dynamic> writeMessageToJson(
      protobuf.GeneratedMessage? generatedMessage) {
    if (generatedMessage == null) return {};

    final fieldInfo = generatedMessage.info_.fieldInfo;
    final json = generatedMessage.writeToJsonMap();

    fieldInfo.forEach(
      (key, value) {
        if (json.containsKey(key.toString())) {
          final field = generatedMessage.getField(key);

          final jsonValue = json[key.toString()];

          json.remove(key.toString());

          if (field is protobuf.GeneratedMessage) {
            json[value.name] = writeMessageToJson(field);
          } else if (field is List<protobuf.GeneratedMessage>) {
            json[value.name] = field.map((e) => writeMessageToJson(e)).toList();
          } else {
            json[value.name] = jsonValue;

            if (jsonValue is String) {
              final base64 = isBase64(jsonValue);

              if (base64) {
                json[value.name] = deCodeOrNull(jsonValue) ?? jsonValue;
              }
            }
          }
        }
      },
    );

    return json;
  }
}
