import 'package:domain/domain.dart';

extension AuraAccountDtoExtension on AuraAccountDto {
  AuraAccount get toEntity {
    return AuraAccount(
      id: id,
      type: type,
      address: address,
      name: name,
      method: method?.toEntity,
      index: index,
    );
  }
}

extension AuraAccountRecoveryMethodDtoExtension on AuraAccountRecoveryMethodDto {
  AuraAccountRecoveryMethod get toEntity {
    return AuraAccountRecoveryMethod(
      method: method,
      value: value,
      subValue: subValue,
    );
  }
}

class AuraAccountDto {
  final int id;
  final int index;
  final AuraAccountType type;
  final String name;
  final String address;
  final AuraAccountRecoveryMethodDto ?method;

  const AuraAccountDto({
    required this.id,
    required this.index,
    required this.type,
    required this.address,
    required this.name,
    this.method,
  });
}

final class AuraAccountRecoveryMethodDto{
  final String value;
  final String subValue;
  final AuraSmartAccountRecoveryMethod method;

  const AuraAccountRecoveryMethodDto({
    required this.method,
    required this.value,
    required this.subValue,
  });
}

