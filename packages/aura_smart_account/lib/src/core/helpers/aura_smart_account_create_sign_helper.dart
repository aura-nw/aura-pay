import 'dart:typed_data';

import 'package:aura_smart_account/src/core/constants/smart_account_constant.dart';
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/tx/signing/v1beta1/export.dart';
import 'package:aura_smart_account/src/proto/cosmos/tx/v1beta1/export.dart'
    as tx;
import 'package:aura_smart_account/src/proto/google/protobuf/export.dart';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:pointycastle/ecc/curves/secp256k1.dart';

sealed class AuraSmartAccountCrateSignHelper {
  Future<void> sign({
    required String address,
    required auth.QueryClient queryClient,
    required List<Any> messages,
  }) async {
    final tx.Fee fee = tx.Fee()..gasLimit = $fixnum.Int64(200000);
    if (!fee.hasGasLimit()) {
      throw Exception('Invalid fees: invalid gas amount specified');
    }

    auth.QueryAccountResponse response = await getAccount(
      address: address,
      queryClient: queryClient,
    );

    // Get pubKey
    final Any pubKey = deserializerAccounts
        .singleWhere(
            (element) => response.account.typeUrl.contains(element.typeUrl))
        .pubKey
        .call(response.account);

    // Create txBody
    final tx.TxBody txBody = tx.TxBody(
      memo: 'Active smart account',
      messages: messages,
    );

    // Get tx Body Bytes
    final Uint8List txBodyBytes = txBody.writeToBuffer();

    final tx.AuthInfo authInfo = tx.AuthInfo(
      fee: tx.Fee.create(),
      signerInfos: [
        tx.SignerInfo(
          publicKey: pubKey,
          modeInfo: tx.ModeInfo(
            single: tx.ModeInfo_Single(
              mode: SignMode.SIGN_MODE_DIRECT,
            ),
          ),
        ),
      ],
    );

    final Uint8List authInfoBytes = authInfo.writeToBuffer();

    final tx.SignDoc signDoc = tx.SignDoc(
      bodyBytes: txBodyBytes,
      authInfoBytes: authInfoBytes,
    );

    final Uint8List makeSignDocToBytes = signDoc.writeToBuffer();


  }

  Future<auth.QueryAccountResponse> getAccount({
    required String address,
    required auth.QueryClient queryClient,
  }) async {
    final auth.QueryAccountRequest queryAccountRequest =
        auth.QueryAccountRequest(
      address: address,
    );

    final auth.QueryAccountResponse account =
        await queryClient.account(queryAccountRequest);

    return account;
  }
}
