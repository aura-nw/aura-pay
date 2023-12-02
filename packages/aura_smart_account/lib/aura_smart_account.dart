library aura_smart_account;

import 'dart:typed_data';

import 'package:aura_smart_account/src/aura_smart_account_impl.dart';
import 'package:aura_smart_account/src/core/definitions/aura_smart_account_environment.dart';
import 'package:aura_smart_account/src/core/definitions/aura_smart_account_error.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart';
import 'package:grpc/grpc.dart';

export 'package:aura_smart_account/src/core/definitions/aura_smart_account_environment.dart';
export 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    show
        QueryGenerateAccountResponse,
        QueryParamsResponse,
        MsgActivateAccountResponse,
        MsgRecoverResponse;
export 'package:aura_smart_account/src/core/definitions/aura_smart_account_error.dart';

/// AuraSmartAccount is an interface. It define some methods to support for aura smart account
/// See more [https://github.com/aura-nw/aura/tree/main/proto/aura/smartaccount/]
abstract interface class AuraSmartAccount {
  /// Create a instance of [AuraSmartAccount]
  /// For example, let's try this code:
  /// final AuraSmartAccount auraSmartAccount = AuraSmartAccount.create(AuraSmartAccountEnvironment)
  /// This method has to pass a [AuraSmartAccountEnvironment] parameter.
  /// [AuraSmartAccountEnvironment] include three kinds.
  /// The first one: [AuraSmartAccountEnvironment.test] for test net.
  /// The second one: [AuraSmartAccountEnvironment.serenity] for serenity net.
  /// The third one: [AuraSmartAccountEnvironment.euphoria] for euphoria.
  /// The fourth one: [AuraSmartAccountEnvironment.production] for production.
  /// After that, you can call all of methods below.
  factory AuraSmartAccount.create(AuraSmartAccountEnvironment environment) {
    return AuraSmartAccountImpl(environment);
  }

  /// Generate a smart account address.
  /// This method has to pass two parameters include: [pubKey] as Uint8List, [salt] as Uint8List?,
  /// Response a [QueryGenerateAccountResponse]
  /// It can throw [AuraSmartAccountError]
  Future<QueryGenerateAccountResponse> generateSmartAccount({
    required Uint8List pubKey,
    Uint8List? salt,
  });

  /// Active a smart account
  /// This method has to pass seven parameters include: [userPrivateKey] as Uint8List,
  /// [smartAccountAddress] as String,
  /// [salt] as Uint8List?,
  /// [memo] as String?,
  /// [fee] as String,
  /// [gasLimit] as int,
  /// Response a [MsgActivateAccountResponse]
  /// It can throw [AuraSmartAccountError]
  Future<MsgActivateAccountResponse> activeSmartAccount({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    Uint8List? salt,
    String? memo,
    required String fee,
    required int gasLimit,
  });

  /// Send token from smart account to address
  /// This method has to pass seven parameters include: [userPrivateKey] as Uint8List,
  /// [smartAccountAddress] as String,
  /// [receiverAddress] as String,
  /// [amount] as String,
  /// [memo] as String?,
  /// [fee] as String,
  /// [gasLimit] as int,
  /// Response a [String] is tx hash of transaction
  /// It can throw [AuraSmartAccountError]
  Future<String> sendToken({
    required Uint8List userPrivateKey,
    required String smartAccountAddress,
    required String receiverAddress,
    required String amount,
    required String fee,
    required int gasLimit,
    String? memo,
  });
}
