import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:wallet_core/src/constants/constants.dart';

sealed class AddressValidator {
  static bool validate({
    required String expectedAddress,
    required String privateKey,
  }) {
    try {
      final List<int> pvBytes = hex.decode(privateKey);

      final pk = PrivateKey.createWithData(Uint8List.fromList(pvBytes));

      final publicKey = pk.getPublicKeySecp256k1(false);

      final AnyAddress anyAddress = AnyAddress.createWithPublicKey(
        publicKey,
        Constants.defaultCoinType,
      );

      return anyAddress.description().toLowerCase() == expectedAddress.toLowerCase();
    } catch (e) {
      return false;
    }
  }
}
