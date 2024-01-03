import 'dart:convert';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/transaction_enum.dart';

sealed class TransactionHelper {
  static MsgSend parseMsgSend(Map<String, dynamic> msg) {
    MsgSend msgSend = MsgSend.create()
      ..fromAddress = msg['from_address']
      ..toAddress = msg['to_address']
      ..amount.addAll(
        (List<Map<String, dynamic>>.from(msg['amount']))
            .map(
              (e) => Coin(amount: e['amount'], denom: e['denom']),
            )
            .toList(),
      );
    return msgSend;
  }

  static bool validateMsgSetRecovery(Map<String, dynamic> msg) {
    final String type = msg['@type'];

    if (type != TransactionType.ExecuteContract) {
      return false;
    }

    return jsonDecode(msg['msg']).containsKey('register_plugin');
  }

  static MsgType getMsgType(List<String> msgTypes) {
    if (msgTypes.contains(TransactionType.Send)) {
      return MsgType.send;
    } else if (msgTypes.contains(TransactionType.Recover)) {
      return MsgType.recover;
    } else if (msgTypes.contains(TransactionType.ExecuteContract)) {
      return MsgType.executeContract;
    }
    return MsgType.other;
  }

  static Future<TransactionInformation> checkTransactionInfo(
    String txHash,
    int times, {
    required SmartAccountUseCase smartAccountUseCase,
  }) async {
    await Future.delayed(
      const Duration(
        milliseconds: 2100,
      ),
    );
    try {
      return await smartAccountUseCase.getTx(
        txHash: txHash,
      );
    } catch (e) {
      if (times == 5) {
        rethrow;
      }
      return checkTransactionInfo(
        txHash,
        times + 1,
        smartAccountUseCase: smartAccountUseCase,
      );
    }
  }
}
