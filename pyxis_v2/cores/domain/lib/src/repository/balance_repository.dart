import 'package:domain/src/entities/balance.dart';
import 'package:domain/src/repository/local_database_repository.dart';

abstract class RemoteBalanceRepository {
  Future<String> getEvmBalanceByAddress({
    required String address,
  });

  Future<String> getCosmosBalanceByAddress({
    required String address,
  });
}

abstract class LocalBalanceRepository
    extends LocalDatabaseRepository<AccountBalance> {
  Future<AccountBalance?> getByAccountID({
    required int accountId,
  });
}

abstract interface class BalanceRepository
    implements RemoteBalanceRepository, LocalBalanceRepository {}
