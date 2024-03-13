import 'package:domain/src/core/aura_account_type.dart';

final class AuraAccount {
  final int id;
  final int index;
  final AuraAccountType type;
  final String name;
  final String address;
  final AuraAccountRecoveryMethod? method;
  final bool needBackup;

  const AuraAccount({
    required this.id,
    required this.index,
    required this.type,
    required this.address,
    required this.name,
    this.method,
    this.needBackup = false,
  });

  bool get isSmartAccount => type == AuraAccountType.smartAccount;

  bool get isVerified => method != null;
}

final class AuraAccountRecoveryMethod {
  final String value;
  final String subValue;
  final AuraSmartAccountRecoveryMethod method;

  const AuraAccountRecoveryMethod({
    required this.method,
    required this.value,
    required this.subValue,
  });
}
