import 'package:data/src/core/base_response.dart';

abstract interface class SmartAccountApiService{
  Future<PyxisBaseResponse> getRecoveryAccountByAddress({
    required Map<String, dynamic> queries,
  });

  Future<PyxisBaseResponse> insertRecoveryAccount({
    required Map<String, dynamic> body,
  });
}