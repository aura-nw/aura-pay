import 'package:data/data.dart';

abstract class GrantFeeApiService {
  Future<PyxisBaseResponse> grantFee({
    required Map<String, dynamic> body,
  });
}
