final class QueryRecoveryAccountParameter {
  final String recoveryAddress;

  const QueryRecoveryAccountParameter({
    required this.recoveryAddress,
  });

  Map<String,dynamic> toJson(){
    return {
      'recover_wallet' : recoveryAddress,
    };
  }
}
