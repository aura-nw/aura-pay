import 'package:data/data.dart';

abstract class RecoveryApiService {
  Future<HasuraBaseResponse> getRecoveryAccountByAddress({
    required Map<String, dynamic> queries,
  });
}
