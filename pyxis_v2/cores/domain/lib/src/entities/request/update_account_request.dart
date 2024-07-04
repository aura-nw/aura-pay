import 'package:domain/domain.dart';

final class UpdateAccountRequest {
  final String? name;
  final String? evmAddress;
  final String? cosmosAddress;
  final int? keyStoreId;
  final AccountType? type;
  final AccountCreateType? createType;
  final int id;

  const UpdateAccountRequest({
    this.name,
    this.createType,
    this.type,
    this.keyStoreId,
    this.evmAddress,
    this.cosmosAddress,
    required this.id,
  });
}
