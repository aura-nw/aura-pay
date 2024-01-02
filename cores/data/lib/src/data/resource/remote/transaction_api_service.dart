import 'package:data/data.dart';

abstract class TransactionApiService {
  Future<AuraBaseResponseV2> getTransaction({
    required Map<String, dynamic> body
  });

  Future<AuraBaseResponseV2> getTransactionDetail({
    required Map<String, dynamic> body
  });
}
