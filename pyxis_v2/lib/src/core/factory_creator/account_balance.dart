import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_v2/src/application/provider/local/balance/balance_database_service_impl.dart';
import 'package:pyxis_v2/src/application/provider/service/balance/balance_service_impl.dart';

BalanceUseCase balanceFactory(Isar isar, Dio dio) {
  return BalanceUseCase(
    BalanceRepositoryImpl(
      BalanceServiceImpl(
        BalanceServiceGenerator(
          dio,
        ),
      ),
      BalanceDatabaseServiceImpl(isar),
    ),
  );
}
