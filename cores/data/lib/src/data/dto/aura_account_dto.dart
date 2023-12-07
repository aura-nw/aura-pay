import 'package:domain/domain.dart';

extension AuraAccountDtoExtension on AuraAccountDto {
  AuraAccount get toEntity {
    return AuraAccount(
      id: id,
      type: type,
      address: address,
      name: name,
    );
  }
}

class AuraAccountDto {
  final int id;
  final AuraAccountType type;
  final String name;
  final String address;

  const AuraAccountDto({
    required this.id,
    required this.type,
    required this.address,
    required this.name,
  });
}
