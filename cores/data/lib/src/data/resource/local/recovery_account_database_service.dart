import 'package:data/src/data/dto/dto.dart';

abstract interface class RecoveryAccountDatabaseService {
  Future<void> deleteAccount(int id);

  Future<void> saveRecoveryAccount({
    required String recoveryAddress,
    required String smartAccountAddress,
    required String name,
  });

  Future<List<LocalRecoveryAccountDto>> getAuraAccounts();
}
