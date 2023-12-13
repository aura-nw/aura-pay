import 'dart:convert';

sealed class AuraSmartAccountConstant {
  static String pubKeyTypeUrl = '/cosmos.crypto.secp256k1.PubKey';

  static final List<int> initMsgDefault = utf8.encode(
    jsonEncode(
      {
        'plugin_manager_addr' : 'aura1y6ww7g6c5yc36363guep6zu004fc3wmdll0ass8ule4syzfceqvsamk8tp'
      },
    ),
  );

  static List<int> executeContractMsg({
    required String smartAccountAddress,
    required String recoverAddress,
  }) =>
      utf8.encode(
        jsonEncode(
          {
            'register_plugin': {
              'plugin_address':
                  'aura1lmq568d3m3n04fq2ca27mjsx2522gljhqcgf3ptcyq2pm3es7y7sxnnqrz',
              'config': {
                'smart_account_address': smartAccountAddress,
                'recover_address': recoverAddress
              },
            },
          },
        ),
      );

  static const int defaultGasActiveSmartAccount = 400000;
  static const int defaultQueryOffset = 0;
  static const int defaultQueryLimit = 100;
}
