import 'dart:convert';

sealed class AuraSmartAccountConstant {
  static String pubKeyTypeUrl = '/cosmos.crypto.secp256k1.PubKey';

  static final List<int> initMsgDefault = utf8.encode(
    jsonEncode(
      {},
    ),
  );

  static int codeId = 729;

  static int errorCodeDefault = 727;
  static int errorBroadcast = 728;
}
