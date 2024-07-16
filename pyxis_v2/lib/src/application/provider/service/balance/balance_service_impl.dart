import 'package:data/data.dart';
import 'package:wallet_core/wallet_core.dart';

final class BalanceServiceImpl implements BalanceService{
  @override
  Future<String> getBalanceByAddress({required String address}) async{
    final amount = await ChainList.auraEuphoria.getWalletBalance(address);
    return amount.toString();
  }

}