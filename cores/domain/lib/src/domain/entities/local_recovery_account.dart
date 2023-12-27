final class LocalRecoveryAccount {
  final int id;
  final String name;
  final String recoveryAddress;
  final String smartAccountAddress;

  const LocalRecoveryAccount({
    required this.id,
    required this.recoveryAddress,
    required this.name,
    required this.smartAccountAddress,
  });
}
