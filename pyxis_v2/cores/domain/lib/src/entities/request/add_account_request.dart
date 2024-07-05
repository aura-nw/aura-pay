import 'package:domain/domain.dart';

final class AddAccountRequest {
  final String name;
  final String evmAddress;
  final String? cosmosAddress;
  final int keyStoreId;
  final AccountType type;
  final AccountCreateType createType;
  final ControllerKeyType controllerKeyType;

  const AddAccountRequest({
    required this.name,
    required this.evmAddress,
    this.cosmosAddress,
    required this.keyStoreId,
    this.type = AccountType.normal,
    this.createType = AccountCreateType.normal,
    this.controllerKeyType = ControllerKeyType.passPhrase,
  });
}
