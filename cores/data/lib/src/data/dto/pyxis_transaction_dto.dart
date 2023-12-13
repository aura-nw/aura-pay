import 'package:domain/domain.dart';

extension PyxisTransactionDtoMapper on PyxisTransactionDto {
  PyxisTransaction get toEntity => PyxisTransaction(
        status: status,
        txHash: txHash,
        timeStamp: timeStamp,
        events: events,
        fee: fee,
        type: type,
        memo: memo,
        amount: amount,
      );
}

final class PyxisTransactionDto {
  final String txHash;
  final int status;
  final String timeStamp;
  final String fee;
  final String type;
  final String? memo;
  final List<String> events;
  final String? amount;

  const PyxisTransactionDto({
    required this.status,
    required this.txHash,
    required this.timeStamp,
    required this.fee,
    required this.type,
    required this.events,
    this.memo,
    this.amount,
  });
}
