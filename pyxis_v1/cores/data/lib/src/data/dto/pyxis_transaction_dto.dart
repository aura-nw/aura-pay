import 'package:data/data.dart';
import 'package:domain/domain.dart';

extension PyxisTransactionDtoMapper on PyxisTransactionDto {
  PyxisTransaction get toEntity => PyxisTransaction(
        status: status,
        txHash: txHash,
        timeStamp: timeStamp,
        heightLt: heightLt,
        messages: messages
            .map(
              (e) => e.toEntity,
            )
            .toList(),
        transactionFees: transactionFees
            .map(
              (e) => e.toEntity,
            )
            .toList(),
      );
}

extension PyxisTransactionMsgDtoMapper on PyxisTransactionMsgDto {
  PyxisTransactionMsg get toEntity => PyxisTransactionMsg(
        type: type,
        content: content,
      );
}

class PyxisTransactionDto {
  final String txHash;
  final int status;
  final int heightLt;
  final String timeStamp;
  final List<PyxisBalanceDto> transactionFees;
  final List<PyxisTransactionMsgDto> messages;

  const PyxisTransactionDto({
    required this.status,
    required this.heightLt,
    required this.txHash,
    required this.timeStamp,
    required this.transactionFees,
    required this.messages,
  });

  bool get isSuccess => status == 0;

  factory PyxisTransactionDto.fromJson(Map<String, dynamic> json) {
    final List<dynamic> feeList = json['fee'];
    final List<dynamic> msgList = json['transaction_messages'];

    return PyxisTransactionDto(
      status: json['code'],
      txHash: json['hash'],
      timeStamp: json['timestamp'],
      heightLt: json['height'],
      transactionFees: feeList
          .map(
            (fee) => PyxisBalanceDto.fromJson(fee),
          )
          .toList(),
      messages:
          msgList.map((msg) => PyxisTransactionMsgDto.fromJson(msg)).toList(),
    );
  }
}

class PyxisTransactionMsgDto {
  final String type;
  final Map<String, dynamic> content;

  const PyxisTransactionMsgDto({
    required this.type,
    required this.content,
  });

  factory PyxisTransactionMsgDto.fromJson(Map<String, dynamic> json) {
    return PyxisTransactionMsgDto(
      type: json['type'],
      content: json['content'],
    );
  }
}
