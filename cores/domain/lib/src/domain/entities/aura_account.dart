import 'package:domain/src/core/aura_account_type.dart';

final class AuraAccount {
  final int id;
  final AuraAccountType type;
  final String name;
  final String address;

  const AuraAccount({
    required this.id,
    required this.type,
    required this.address,
    required this.name,
  });

  bool get isSmartAccount => type == AuraAccountType.smartAccount;
}
