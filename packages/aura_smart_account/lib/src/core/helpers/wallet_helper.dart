import 'dart:typed_data';

import 'package:aura_smart_account/src/core/utils/big_int.dart';
import 'package:bech32/bech32.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:pointycastle/macs/hmac.dart';

sealed class WalletHelper {
  static Uint8List getPublicKeyFromPrivateKey(Uint8List privateKey){
    final secp256k1 = ECCurve_secp256k1();
    final point = secp256k1.G;

    final bigInt = BigInt.parse(HEX.encode(privateKey), radix: 16);
    final curvePoint = point * bigInt;

    return curvePoint!.getEncoded();
  }

  static Uint8List getBech32AddressFromPublicKey(Uint8List publicKey){
    final Uint8List sha256Digest = SHA256Digest().process(publicKey);
    final Uint8List address = RIPEMD160Digest().process(sha256Digest);
    return address;
  }

  static Uint8List createSignature(
      Uint8List hashedMessage, Uint8List privateKey) {
    final ecPrivateKey = ECPrivateKey(
      BigInt.parse(HEX.encoder.convert(privateKey), radix: 16),
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

  static String encodeBech32Address(String humanReadablePart, Uint8List data) {
    final List<int> converted = _convertBits(data, 8, 5);
    const bech32Codec =  Bech32Codec();
    final bech32Data = Bech32(humanReadablePart, Uint8List.fromList(converted));
    return bech32Codec.encode(bech32Data);
  }

  /// for bech32 coding
  static Uint8List _convertBits(
      List<int> data,
      int from,
      int to, {
        bool pad = true,
      }) {
    var acc = 0;
    var bits = 0;
    final result = <int>[];
    final maxv = (1 << to) - 1;

    for (var v in data) {
      if (v < 0 || (v >> from) != 0) {
        throw Exception();
      }
      acc = (acc << from) | v;
      bits += from;
      while (bits >= to) {
        bits -= to;
        result.add((acc >> bits) & maxv);
      }
    }

    if (pad) {
      if (bits > 0) {
        result.add((acc << (to - bits)) & maxv);
      }
    } else if (bits >= from) {
      throw Exception('illegal zero padding');
    } else if (((acc << (to - bits)) & maxv) != 0) {
      throw Exception('non zero');
    }

    return Uint8List.fromList(result);
  }
}
