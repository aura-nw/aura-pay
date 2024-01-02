import 'package:data/data.dart';

abstract interface class TokenApiService {
  Future<AuraBaseResponseV1> getAuraTokenPrice();
}
