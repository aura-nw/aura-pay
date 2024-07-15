import 'package:data/core/base_response.dart';

abstract interface class RemoteTokenMarketService {
  Future<AuraBaseResponseV1> getRemoteTokenMarket();
}