import 'package:domain/src/core/aura_account_type.dart';

final class SaveAccountRequestParameter {
  final String address;
  final String accountName;
  final AuraAccountType type;
  final AuraAccountCreateType createdType;
  final bool needBackup;

  const SaveAccountRequestParameter({
    required this.address,
    required this.accountName,
    required this.type,
    this.createdType = AuraAccountCreateType.normal,
    this.needBackup = false,
  });
}
