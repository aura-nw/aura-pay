import 'entities.dart';

final class PyxisTransaction {
  final String txHash;
  final int status;
  final int heightLt;
  final String timeStamp;
  final List<PyxisBalance> transactionFees;
  final List<PyxisTransactionMsg> messages;

  const PyxisTransaction({
    required this.status,
    required this.txHash,
    required this.heightLt,
    required this.timeStamp,
    required this.transactionFees,
    required this.messages,
  });

  bool get isSuccess => status == 0;
}

final class PyxisTransactionMsg {
  final String type;
  final Map<String,dynamic> content;

  const PyxisTransactionMsg({
    required this.type,
    required this.content,
  });
}
