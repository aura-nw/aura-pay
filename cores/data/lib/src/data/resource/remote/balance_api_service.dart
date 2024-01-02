import 'package:data/data.dart';

abstract interface class BalanceApiService {
  Future<AuraBaseResponseV2> getBalances({required Map<String,dynamic> body,});
}
