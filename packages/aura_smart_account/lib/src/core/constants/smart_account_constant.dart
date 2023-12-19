import 'dart:convert';

sealed class AuraSmartAccountConstant {
  static String pubKeyTypeUrl = '/cosmos.crypto.secp256k1.PubKey';
  static String msgRecoverTypeUrl = '/aura.smartaccount.v1beta1.MsgRecover';

  static List<int> initMsgDefault({
    required String pluginManager,
  }) =>
      utf8.encode(
        jsonEncode(
          {
            'plugin_manager_addr': pluginManager,
          },
        ),
      );

  static List<int> setRecoveryMsg({
    required String smartAccountAddress,
    required String recoverAddress,
    required String recoveryContractAddress,
  }) =>
      utf8.encode(
        jsonEncode(
          {
            'register_plugin': {
              'plugin_address': recoveryContractAddress,
              'config': jsonEncode({
                'smart_account_address': smartAccountAddress,
                'recover_address': recoverAddress
              }),
            },
          },
        ),
      );

  static List<int> unRegisterRecovery({
    required String recoveryContractAddress,
  }) =>
      utf8.encode(
        jsonEncode(
          {
            'unregister_plugin': {
              'plugin_address': recoveryContractAddress,
            },
          },
        ),
      );

  static const int defaultGasActiveSmartAccount = 400000;
  static const String maxFeeGrant = '1000000';
  static const int defaultQueryOffset = 0;
  static const int defaultQueryLimit = 100;
}
