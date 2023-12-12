import 'package:domain/src/core/aura_account_type.dart';

final class AuraAccount {
  final int id;
  final AuraAccountType type;
  final String name;
  final String address;
  final AuraAccountRecoveryMethod? method;

  const AuraAccount({
    required this.id,
    required this.type,
    required this.address,
    required this.name,
    this.method,
  });

  bool get isSmartAccount => type == AuraAccountType.smartAccount;

  bool get isVerified => method != null;
}

final class AuraAccountRecoveryMethod {
  final String value;
  final AuraSmartAccountRecoveryMethod method;

  const AuraAccountRecoveryMethod({
    required this.method,
    required this.value,
  });
}
