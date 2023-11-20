library aura_smart_account;

import 'package:aura_smart_account/src/aura_smart_account_impl.dart';
import 'package:aura_smart_account/src/core/definitions/aura_smart_account_environment.dart';
import 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart';
import 'package:grpc/grpc.dart';

export 'package:aura_smart_account/src/core/definitions/aura_smart_account_environment.dart';
export 'package:aura_smart_account/src/proto/aura/smartaccount/v1beta1/export.dart'
    show
        QueryGenerateAccountResponse,
        QueryParamsResponse,
        MsgActivateAccountResponse,
        MsgRecoverResponse;

/// AuraSmartAccount is an interface. It define some methods to support for aura smart account
/// See more [https://github.com/aura-nw/aura/tree/main/proto/aura/smartaccount/]
abstract interface class AuraSmartAccount {
  /// Create a instance of [AuraSmartAccount]
  /// For example, let's try this code:
  /// final AuraSmartAccount auraSmartAccount = AuraSmartAccount.create(AuraSmartAccountEnvironment)
  /// This method has to pass a [AuraSmartAccountEnvironment] parameter.
  /// [AuraSmartAccountEnvironment] include three kinds.
  /// The first one: [AuraSmartAccountEnvironment.serenity] for test net.
  /// The second one: [AuraSmartAccountEnvironment.euphoria] for euphoria.
  /// The third one: [AuraSmartAccountEnvironment.production] for production.
  /// After that, you can call all of methods below.
  factory AuraSmartAccount.create(AuraSmartAccountEnvironment environment) {
    return AuraSmartAccountImpl(environment);
  }

  /// Generate a smart account address.
  /// This method has to pass two parameters include:, [pubKey] as List<int>, [salt] as List<int>?,
  /// Response a [QueryGenerateAccountResponse]
  /// It can throw [GrpcError]
  Future<QueryGenerateAccountResponse> generateSmartAccount({
    required List<int> pubKey,
    List<int>? salt,
  });

  /// Active a smart account
  /// It can throw [GrpcError]
  Future<MsgActivateAccountResponse> activeSmartAccount({
    required String smartAccountAddress,
    required List<int> pubKey,
    List<int>? salt,

  });
}
