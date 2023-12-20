import 'dart:convert';

import 'package:aura_smart_account/aura_smart_account.dart';
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

  static MsgRecover parseMsgRecover(Map<String, dynamic> msg) {
    MsgRecover msgRecover = MsgRecover.create();

    return msgRecover;
  }

  static MsgExecuteContract parseMsgExecuteContract(Map<String, dynamic> msg) {
    MsgExecuteContract msgExecuteContract = MsgExecuteContract.create()
      ..msg = utf8.encode(msg['msg'].toString())
      ..contract = msg['contract']
      ..sender = msg['sender'];

    return msgExecuteContract;
  }

  static bool validateMsgSetRecovery(Map<String,dynamic> msg){
    final String type = msg['@type'];

    if(type!= TransactionType.ExecuteContract){
      return false;
    }

    return jsonDecode(msg['msg']).containsKey('register_plugin');
  }

  static MsgType getMsgType(Map<String, dynamic> msg) {
    final String type = msg['@type'];
    switch (type) {
      case TransactionType.Send:
        return MsgType.send;
      case TransactionType.Recover:
        return MsgType.recover;
      case TransactionType.ExecuteContract:
        return MsgType.executeContract;
      default:
        return MsgType.other;
    }
  }
}
