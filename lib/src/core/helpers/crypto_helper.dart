import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
sealed class CryptoHelper{
  static String hashStringBySha256(String value){
    final Uint8List bytes = utf8.encode(value);

    final Digest digest = sha256.convert(bytes);

    return digest.toString();
  }
}