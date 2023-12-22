import 'package:data/data.dart';

abstract class TransactionApiService {
  Future<BaseResponseV2> getTransaction({
    required Map<String, dynamic> body
  });
}
