import 'package:domain/src/domain/entities/entities.dart';

abstract interface class RecoveryRepository{
  Future<List<PyxisRecoveryAccount>> getRecoveryAccountByAddress({
    required Map<String, dynamic> queries,
    required String accessToken,
  });
}