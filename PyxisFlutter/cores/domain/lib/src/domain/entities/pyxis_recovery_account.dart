final class PyxisRecoveryAccount {
  final int id;
  final String? name;
  final String smartAccountAddress;

  const PyxisRecoveryAccount({
    required this.id,
    required this.smartAccountAddress,
    this.name,
  });
}
