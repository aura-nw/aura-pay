class SendTransactionInformation {
  final String timestamp;
  final String txHash;
  final int status;

  const SendTransactionInformation({
    required this.txHash,
    required this.timestamp,
    required this.status,
  });
}
