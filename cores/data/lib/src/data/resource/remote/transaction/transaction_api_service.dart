import 'package:data/src/data/resource/remote/api_service.dart';

abstract class TransactionApiService {
  Future<TransactionBaseResponse> getTransaction({
    required Map<String, dynamic> queries
  });
}
