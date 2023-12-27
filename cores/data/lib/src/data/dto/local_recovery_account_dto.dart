import 'package:domain/domain.dart';

extension LocalRecoveryAccountDtoMapper on LocalRecoveryAccountDto {
  LocalRecoveryAccount get toEntity => LocalRecoveryAccount(
        recoveryAddress: recoveryAddress,
        name: name,
        smartAccountAddress: smartAccountAddress,
        id: id,
      );
}

class LocalRecoveryAccountDto {
  final int id;
  final String name;
  final String recoveryAddress;
  final String smartAccountAddress;

  const LocalRecoveryAccountDto({
    required this.id,
    required this.recoveryAddress,
    required this.name,
    required this.smartAccountAddress,
  });
}
