import 'package:domain/src/core/aura_account_type.dart';

final class RenameAccountRequestParameter {
  final int id;
  final String? accountName;
  final String? address;
  final AuraAccountType? type;
  final AuraSmartAccountRecoveryMethod? method;
  final String? value;

  const RenameAccountRequestParameter({
    required this.id,
    this.accountName,
    this.address,
    this.type,
    this.method,
    this.value,
  });
}
