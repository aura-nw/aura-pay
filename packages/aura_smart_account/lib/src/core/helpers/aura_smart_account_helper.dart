import 'dart:typed_data';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart';
import 'package:aura_smart_account/src/proto/cosmos/tx/signing/v1beta1/export.dart'
    as signing;
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart';
import 'wallet_helper.dart';

typedef AccountDeserializer = Account Function(Any);

sealed class AuraSmartAccountHelper {
  static final Map<String, AccountDeserializer> _deserializerAccounts = {
    'BaseAccount': BaseAccount.fromAny,
    'ModuleAccount': ModuleAccount.fromAny,
    'BaseVestingAccount': BaseVestingAccount.fromAny,
    'DelayedVestingAccount': DelayedVestingAccount.fromAny,
    'ContinuousVestingAccount': ContinuousVestingAccount.fromAny,
    'PeriodicVestingAccount': PeriodicVestingAccount.fromAny,
  };

  static Future<tx.Tx> sign({
    required String bech32Hrp,
    required Uint8List privateKey,
    required auth.QueryClient queryClient,
    required List<Any> messages,
    required SmartAccount signerData,
    required String chainId,
    required tx.Fee fee,
    String? memo,
  }) async {

    if (!fee.hasGasLimit()) {
      throw Exception('Invalid fees: invalid gas amount specified');
    }

    // get user Address from privateKey
    final Uint8List userAddressBytes =
    WalletHelper.getBech32AddressFromPublicKey(
      WalletHelper.getPublicKeyFromPrivateKey(
        privateKey,
      ),
    );
    final String userAddress = WalletHelper.encodeBech32Address(
      bech32Hrp,
      userAddressBytes,
    );

    // get account from user address
    Account account = await getAccount(
      address: userAddress,
      queryClient: queryClient,
    );

    // Create txBody
    final tx.TxBody txBody = tx.TxBody(
      memo: memo,
      messages: messages,
    );

    // Get tx Body Bytes
    final Uint8List txBodyBytes = txBody.writeToBuffer();

    // Create auth Infor
    final tx.AuthInfo authInfo = tx.AuthInfo(
      fee: tx.Fee.create(),
      signerInfos: [
        tx.SignerInfo(
          publicKey: account.pubKey(),
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
      chainId: chainId,
    );

    // Get sign doc bytes
    final Uint8List makeSignDocToBytes = signDoc.writeToBuffer();

    // Create signature
    final Uint8List signature = WalletHelper.createSignature(
      makeSignDocToBytes,
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
    final auth.QueryAccountRequest queryAccountRequest =
        auth.QueryAccountRequest(
      address: address,
    );

    final auth.QueryAccountResponse response =
        await queryClient.account(queryAccountRequest);

    if (!response.hasAccount()) {
      throw Exception(
        'Account $address does not exist on chain',
      );
    }

    final String key = _deserializerAccounts.keys
        .singleWhere((element) => response.account.typeUrl.contains(element));

    return _deserializerAccounts[key]!.call(response.account);
  }
}
