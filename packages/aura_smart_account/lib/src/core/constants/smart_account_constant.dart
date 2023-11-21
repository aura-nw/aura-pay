import 'dart:convert';

class AuraSmartAccountConstant{
  static String pubKeyTypeUrl = '/cosmos.crypto.secp256k1.PubKey';

  static final List<int> initMsgDefault = utf8.encode(
    jsonEncode(
      {
        'plugin_manager_addr':
        'aura1mjq9u2pteesx4wr4u3ddnxhxcspyz2yk7rt4snq820la0cwpruvs0qkhk8',
      },
    ),
  );

  static int codeId = 726;
}
