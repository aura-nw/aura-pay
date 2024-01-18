import 'dart:convert';
import 'dart:typed_data';
import 'package:hex/hex.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/export.dart';

sealed class CryptoUtil {
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

  static AsymmetricKeyPair<ECPublicKey, ECPrivateKey> createKeyPair({
    required String seed,
  }) {
    final SecureRandom secureRandom = createSecureRandom(
      seed: seed,
    );

    final KeyGenerator keyGenerator = ECKeyGenerator();
    final ParametersWithRandom keyGenParams = ParametersWithRandom(
      ECKeyGeneratorParameters(
        ECDomainParameters(
          'secp256k1',
        ),
      ),
      secureRandom,
    );
    keyGenerator.init(keyGenParams);
    AsymmetricKeyPair keyPair = keyGenerator.generateKeyPair();

    final publicKey = keyPair.publicKey as ECPublicKey;

    final privateKey = keyPair.privateKey as ECPrivateKey;

    return AsymmetricKeyPair(publicKey, privateKey);
  }

  static Uint8List createSignatureByPrivateKey({
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
  
  static String encodeBytes(Uint8List bytes){
    return HEX.encode(bytes);
  }
}
