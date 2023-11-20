import 'package:aura_smart_account/src/core/definitions/grpc_client_channel.dart';

sealed class AuraNetWorkInformation {
  static const GrpcClientChannel serenityChannel = GrpcClientChannel(
    host: 'grpc.serenity.aura.network',
    port: 9092,
  );
  static const GrpcClientChannel euphoriaChannel = GrpcClientChannel(
    host: 'rpc.euphoria.aura.network',
    port: 9090,
    grpcTransportSecure: true,
  );
  static const GrpcClientChannel productionChannel = GrpcClientChannel(
    host: 'rpc.aura.network',
    port: 9090,
    grpcTransportSecure: true,
  );
}
