import 'dart:convert';

sealed class AuraSmartAccountConstant {
  static String pubKeyTypeUrl = '/cosmos.crypto.secp256k1.PubKey';

  static final List<int> initMsgDefault = utf8.encode(
    jsonEncode(
      {},
    ),
  );

  static const int defaultGasActiveSmartAccount = 400000;
  static const int defaultQueryOffset = 0;
  static const int defaultQueryLimit = 100;
}
