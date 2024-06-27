import 'dart:typed_data';

import 'package:aura_smart_account/src/core/utils/big_int.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:pointycastle/macs/hmac.dart';

sealed class WalletHelper {

  /// This method generate pub key from private key
  static Uint8List getPublicKeyFromPrivateKey(Uint8List privateKey){
    final secp256k1 = ECCurve_secp256k1();
    final point = secp256k1.G;

    final bigInt = BigInt.parse(HEX.encode(privateKey), radix: 16);
    final curvePoint = point * bigInt;

    return curvePoint!.getEncoded();
  }

  /// Create a signature form private key and hashMessage
  static Uint8List createSignature(
      Uint8List hashedMessage, Uint8List privateKey) {
    final ecPrivateKey = ECPrivateKey(
      BigInt.parse(HEX.encode(privateKey), radix: 16),
      ECCurve_secp256k1(),
    );

    final hash = SHA256Digest().process(hashedMessage);

    final ecdsaSigner = ECDSASigner(null, HMac(SHA256Digest(), 64))
      ..init(true, PrivateKeyParameter(ecPrivateKey));

    final ecSignature = ecdsaSigner.generateSignature(hash) as ECSignature;

    var normalizedS = ecSignature.s;

    if (normalizedS.compareTo(ECCurve_secp256k1().n >> 1) > 0) {
      normalizedS = ECCurve_secp256k1().n - normalizedS;
    }
    final normalized = ECSignature(ecSignature.r, normalizedS);

    final rBytes = normalized.r.toUin8List();
    final sBytes = normalized.s.toUin8List();

    var sigBytes = Uint8List(64);

    _copy(rBytes, 32 - rBytes.length, 32, sigBytes);
    _copy(sBytes, 64 - sBytes.length, 64, sigBytes);

    return sigBytes;
  }

  /// Just for create signature
  static void _copy(
      Uint8List source, int start, int end, Uint8List destination) {
    var index = 0;
    for (var i = start; i < end; i++) {
      destination[i] = source[index];
      index++;
    }
  }
}
