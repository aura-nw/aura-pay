import 'dart:convert';
import 'package:aura_smart_account/src/core/definitions/account.dart';
import 'package:aura_smart_account/src/proto/cosmos/auth/v1beta1/export.dart'
    as auth;
import 'package:aura_smart_account/src/proto/cosmos/vesting/v1beta1/export.dart'
    as vesting;

const String pubKeyTypeUrl = '/cosmos.crypto.secp256k1.PubKey';

final List<int> initMsgDefault = utf8.encode(
  jsonEncode(
    {
      'plugin_manager_addr':
          'aura1mjq9u2pteesx4wr4u3ddnxhxcspyz2yk7rt4snq820la0cwpruvs0qkhk8',
    },
  ),
);

const int codeId = 726;

List<Account> deserializerAccounts = [
  Account(
    typeUrl: 'BaseAccount',
    pubKey: (any) {
      return auth.BaseAccount.fromBuffer(any.value).pubKey;
    },
  ),
  Account(
    typeUrl: 'ModuleAccount',
    pubKey: (any) {
      return auth.ModuleAccount.fromBuffer(any.value).baseAccount.pubKey;
    },
  ),
  Account(
    typeUrl: 'BaseVestingAccount',
    pubKey: (any) {
      return vesting.BaseVestingAccount.fromBuffer(any.value)
          .baseAccount
          .pubKey;
    },
  ),
  Account(
    typeUrl: 'DelayedVestingAccount',
    pubKey: (any) {
      return vesting.DelayedVestingAccount.fromBuffer(any.value)
          .baseVestingAccount
          .baseAccount
          .pubKey;
    },
  ),
  Account(
    typeUrl: 'ContinuousVestingAccount',
    pubKey: (any) {
      return vesting.ContinuousVestingAccount.fromBuffer(any.value)
          .baseVestingAccount
          .baseAccount
          .pubKey;
    },
  ),
  Account(
    typeUrl: 'PeriodicVestingAccount',
    pubKey: (any) {
      return vesting.PeriodicVestingAccount.fromBuffer(any.value)
          .baseVestingAccount
          .baseAccount
          .pubKey;
    },
  ),
];
