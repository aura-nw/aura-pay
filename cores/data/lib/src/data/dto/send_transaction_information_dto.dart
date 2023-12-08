import 'package:domain/domain.dart';

extension SendTransactionInformationDtoMapper on SendTransactionInformationDto {
  SendTransactionInformation get toEntity => SendTransactionInformation(
        txHash: txHash,
        timestamp: timestamp,
        status: status,
      );
}

class SendTransactionInformationDto {
  final String timestamp;
  final String txHash;
  final int status;

  const SendTransactionInformationDto({
    required this.txHash,
    required this.timestamp,
    required this.status,
  });
}
