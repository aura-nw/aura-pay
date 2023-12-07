import 'package:domain/domain.dart';

extension SendTransactionInformationDtoMapper on SendTransactionInformationDto {
  SendTransactionInformation get toEntity => SendTransactionInformation(
        txHash: txHash,
        timestamp: timestamp,
      );
}

class SendTransactionInformationDto {
  final String timestamp;
  final String txHash;

  const SendTransactionInformationDto({
    required this.txHash,
    required this.timestamp,
  });
}
