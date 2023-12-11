final class PyxisTransaction {
  final String txHash;
  final int status;
  final String timeStamp;
  final PyxisTransactionEvent event;

  const PyxisTransaction({
    required this.status,
    required this.txHash,
    required this.timeStamp,
    required this.event,
  });

  bool get isSuccess => status == 0;
}

final class PyxisTransactionEvent {
  final String type;
  final List<PyxisTransactionAttribute> values;

  const PyxisTransactionEvent({
    required this.values,
    required this.type,
  });
}

final class PyxisTransactionAttribute {
  final String key;
  final String value;

  const PyxisTransactionAttribute({
    required this.key,
    required this.value,
  });
}
