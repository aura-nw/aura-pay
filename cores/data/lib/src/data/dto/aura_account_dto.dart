import 'package:domain/domain.dart';
import 'package:isar/isar.dart';

part 'aura_account_dto.g.dart';

extension AuraAccountDtoExtension on AuraAccountDto {
  AuraAccount get toEntity {
    return AuraAccount(
      id: id,
      type: type,
      address: address,
      name: name,
    );
  }

  AuraAccountDto copyWith({
    AuraAccountType? type,
    String? address,
    String? name,
  }) {
    return AuraAccountDto(
      type: type ?? this.type,
      address: address ?? this.address,
      name: name ?? this.name,
    );
  }
}

@Collection(inheritance: false)
class AuraAccountDto {
  final Id id = Isar.autoIncrement;
  @enumerated
  final AuraAccountType type;
  final String? name;
  final String address;

  const AuraAccountDto({
    required this.type,
    required this.address,
    required this.name,
  });
}
