final class PyxisTransaction {
  final String txHash;
  final int status;
  final String timeStamp;
  final String fee;
  final String? memo;
  final Map<String,dynamic> msg;

  const PyxisTransaction({
    required this.status,
    required this.txHash,
    required this.timeStamp,
    required this.fee,
    required this.msg,
    this.memo,
  });

  bool get isSuccess => status == 0;
}
