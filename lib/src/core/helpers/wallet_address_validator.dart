import 'package:bech32/bech32.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';

sealed class WalletAddressValidator {
  static bool isValidAddress(String address) {
    final config = getIt.get<PyxisMobileConfig>();
    try{
      const Bech32Codec bech32codec = Bech32Codec();

      final bech32Data = bech32codec.decode(address);

      return bech32Data.hrp.toLowerCase() == config.symbol.toLowerCase();
    }catch(e){
      return false;
    }
  }
}
