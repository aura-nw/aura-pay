class TransactionInformation {
  final String timestamp;
  final String txHash;
  final String rawLog;
  final int status;

  const TransactionInformation({
    required this.txHash,
    required this.timestamp,
    required this.status,
    required this.rawLog,
  });
}
