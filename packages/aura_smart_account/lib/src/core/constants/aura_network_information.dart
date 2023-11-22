import 'package:aura_smart_account/src/core/definitions/grpc_network_info.dart';

sealed class AuraNetWorkInformationConstant {
  static const AuraNetworkInfo testChannel = AuraNetworkInfo(
    host: 'grpc.dev.aura.network',
    port: 443,
    chainId: 'aura-testnet-2',
    bech32Hrp: 'aura',
    denom: 'utaura',
    grpcTransportSecure: true,
  );
  static const AuraNetworkInfo serenityChannel = AuraNetworkInfo(
    host: 'grpc.serenity.aura.network',
    port: 9092,
    chainId: 'serenity-testnet-001',
    bech32Hrp: 'aura',
    denom: 'uaura',
    grpcTransportSecure: false,
  );
  static const AuraNetworkInfo euphoriaChannel = AuraNetworkInfo(
    host: 'rpc.euphoria.aura.network',
    port: 9090,
    grpcTransportSecure: true,
    chainId: 'euphoria-2',
    bech32Hrp: '',
    denom: 'ueaura',
  );
  static const AuraNetworkInfo productionChannel = AuraNetworkInfo(
    host: 'rpc.aura.network',
    port: 9090,
    grpcTransportSecure: true,
    chainId: 'xstaxy-1',
    bech32Hrp: 'aura',
    denom: 'uaura',
  );
}
