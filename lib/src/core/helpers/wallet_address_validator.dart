import 'package:bech32/bech32.dart';

sealed class WalletAddressValidator {
  static bool isValidAddress(String address) {
    try{
      const Bech32Codec bech32codec = Bech32Codec();

      final bech32Data = bech32codec.decode(address);

      return bech32Data.hrp == 'aura';
    }catch(e){
      return false;
    }
  }
}
