final class InsertRecoveryAccountParameter {
  final String name;
  final String recoveryAddress;
  final String smartAccountAddress;

  const InsertRecoveryAccountParameter({
    required this.recoveryAddress,
    required this.name,
    required this.smartAccountAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'object': {
        'name': name,
        'wallet_address': smartAccountAddress,
        'recover_wallet': recoveryAddress,
      },
    };
  }
}
