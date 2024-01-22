import 'dart:convert';
import 'package:hex/hex.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'dart:typed_data';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
sealed class CryptoUtil{

  static SecureRandom createSecureRandom({
    required String seed,
  }) {
    final List<int> seedBytes = List<int>.empty(growable: true)
      ..addAll(seed.codeUnits);

    if (seedBytes.length < 32) {
      seedBytes.addAll(List<int>.filled(32 - seedBytes.length, 0));
    } else if (seedBytes.length > 32) {
      seedBytes.removeRange(32, seedBytes.length);
    }

    final SecureRandom secureRandom = FortunaRandom()
      ..seed(
        KeyParameter(
          Uint8List.fromList(seedBytes),
        ),
      );

    return secureRandom;
  }

  static Uint8List createSignature({
    required String message,
    required String seed,
    required ECPrivateKey privateKey,
  }) {
    // Create secure random
    final SecureRandom secureRandom = createSecureRandom(seed: seed);

    Uint8List messageBytes = Uint8List.fromList(
      utf8.encode(
        message,
      ),
    );

    // Sign the message using ECDSA private key and SHA-256 digest
    ECDSASigner signer = ECDSASigner(null, HMac(SHA256Digest(), 64))
      ..init(
          true,
          ParametersWithRandom(
            PrivateKeyParameter<ECPrivateKey>(privateKey),
            secureRandom,
          ));
    ECSignature signature =
    signer.generateSignature(messageBytes) as ECSignature;

    // Convert the signature to a DER-encoded bytes
    ASN1Sequence sequence = ASN1Sequence(
      elements: [
        ASN1Integer(signature.r),
        ASN1Integer(signature.s),
      ],
    );
    Uint8List derSignature = sequence.encode();

    return derSignature;
  }

  static Uint8List getPublicKeyByKeyPair(AsymmetricKeyPair<ECPublicKey, ECPrivateKey> keyPair) {
    return keyPair.publicKey.Q!.getEncoded(true);
  }

  static AsymmetricKeyPair<ECPublicKey, ECPrivateKey> generateKeyPairByPrivateKey(
      Uint8List privateKeyBytes,
      ) {
    final domainParams = ECCurve_secp256k1();

    final privateKey = ECPrivateKey(
      BigInt.parse(HEX.encode(privateKeyBytes), radix: 16),
      domainParams,
    );

    final publicKey =
    ECPublicKey(privateKey.parameters!.G * privateKey.d, domainParams);

    return AsymmetricKeyPair(
      publicKey,
      privateKey,
    );
  }
}