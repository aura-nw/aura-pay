import 'package:domain/src/core/aura_account_type.dart';

final class SaveAccountRequestParameter {
  final String address;
  final String ?accountName;
  final AuraAccountType type;

  const SaveAccountRequestParameter({
    required this.address,
    this.accountName,
    required this.type,
  });
}
