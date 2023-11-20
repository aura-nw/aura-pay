import 'dart:convert';
import 'dart:typed_data';

import 'package:aura_smart_account/src/core/constants/smart_account_constant.dart';
import 'package:aura_smart_account/src/proto/cosmos/crypto/ed25519/export.dart'
    as crypto;
import 'package:protobuf/protobuf.dart';

import '../../proto/google/protobuf/any.pb.dart';

sealed class CosmosHelper {
  static encodeSecp256k1Pubkey(Uint8List pubkey) {
    if (pubkey.length != 33 || (pubkey[0] != 0x02 && pubkey[0] != 0x03)) {
      throw Exception(
          "Public key must be compressed secp256k1, i.e., 33 bytes starting with 0x02 or 0x03");
    }

    return base64Encode(pubkey);
  }

  static Any encodePubkey(
    String pubKeyString,
  ) {
    final crypto.PubKey pubKey = crypto.PubKey(
      key: base64Decode(
        pubKeyString,
      ),
    );
    return Any(
      typeUrl: pubKeyTypeUrl,
      value: Uint8List(0),
    );
  }
}