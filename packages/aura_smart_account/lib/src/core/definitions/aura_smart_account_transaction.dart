final class AuraSmartAccountTransaction {
  final String txHash;
  final int status;
  final String timeStamp;
  final AuraSmartAccountEvent event;

  const AuraSmartAccountTransaction({
    required this.status,
    required this.txHash,
    required this.timeStamp,
    required this.event,
  });

  bool get isSuccess => status == 0;
}

final class AuraSmartAccountEvent {
  final String type;
  final List<AuraSmartAccountAttribute> values;

  const AuraSmartAccountEvent({
    required this.values,
    required this.type,
  });
}

final class AuraSmartAccountAttribute {
  final String key;
  final String value;

  const AuraSmartAccountAttribute({
    required this.key,
    required this.value,
  });
}
