import 'package:data/data.dart';

abstract interface class BalanceApiService {
  Future<BaseResponseV1> getTokenPrice();
  Future<BaseResponseV2> getBalances({required Map<String,dynamic> body,});
}
