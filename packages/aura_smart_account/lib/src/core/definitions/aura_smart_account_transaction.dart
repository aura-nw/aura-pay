final class AuraSmartAccountTransaction {
  final String txHash;
  final int status;
  final String timeStamp;
  final String fee;
  final String type;
  final String? memo;
  final List<String> events;
  final String ?amount;

  const AuraSmartAccountTransaction({
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
