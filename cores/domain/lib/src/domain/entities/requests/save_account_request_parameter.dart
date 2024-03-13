import 'package:domain/src/core/aura_account_type.dart';

final class SaveAccountRequestParameter {
  final String address;
  final String accountName;
  final AuraAccountType type;
  final bool needBackup;

  const SaveAccountRequestParameter({
    required this.address,
    required this.accountName,
    required this.type,
    this.needBackup = false,
  });
}
