import 'package:domain/domain.dart';

extension TransactionInformationDtoMapper on TransactionInformationDto {
  TransactionInformation get toEntity => TransactionInformation(
        txHash: txHash,
        timestamp: timestamp,
        status: status,
        rawLog: rawLog,
      );
}

class TransactionInformationDto {
  final String timestamp;
  final String rawLog;
  final String txHash;
  final int status;

  const TransactionInformationDto({
    required this.txHash,
    required this.timestamp,
    required this.status,
    required this.rawLog,
  });
}
