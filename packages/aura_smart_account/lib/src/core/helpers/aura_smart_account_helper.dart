import 'dart:typed_data';
import 'package:aura_smart_account/src/core/constants/aura_network_information.dart';
import 'package:aura_smart_account/src/core/constants/smart_account_constant.dart';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/core/definitions/aura_smart_account_environment.dart';
import 'package:aura_smart_account/src/core/definitions/cosmos_signer_data.dart';
import 'package:aura_smart_account/src/core/definitions/grpc_network_info.dart';
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/tx/signing/v1beta1/export.dart'
    as signing;
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart' as pb;
import 'package:aura_smart_account/src/proto/cosmos/crypto/secp256k1/export.dart'
    as secp256;
import 'package:hex/hex.dart';
import 'wallet_helper.dart';

typedef AccountDeserializer = Account Function(pb.Any);

sealed class AuraSmartAccountHelper {

  static AuraNetworkInfo getNetworkInfoFromEnvironment(AuraSmartAccountEnvironment environment){
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

  static Future<Account> getAccount({
    required String address,
    required auth.QueryClient queryClient,
  }) async {
    // Create ath account request
    final auth.QueryAccountRequest queryAccountRequest =
        auth.QueryAccountRequest(
      address: address,
    );

    // Get account
    final auth.QueryAccountResponse response =
        await queryClient.account(queryAccountRequest);

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

  static String encodeByte(Uint8List bytes){
    return HEX.encode(bytes);
  }
}
