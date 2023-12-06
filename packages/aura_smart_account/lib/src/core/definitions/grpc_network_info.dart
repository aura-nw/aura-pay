import 'package:grpc/grpc_or_grpcweb.dart';

final class AuraNetworkInfo {
  final String host;
  final int port;
  final bool grpcTransportSecure;
  final String chainId;
  final String bech32Hrp;
  final String denom;
  final int codeId;

  const AuraNetworkInfo({
    required this.host,
    this.port = 9092,
    this.grpcTransportSecure = false,
    required this.chainId,
    required this.bech32Hrp,
    required this.denom,
    required this.codeId,
  });

  GrpcOrGrpcWebClientChannel getChannel() {
    return GrpcOrGrpcWebClientChannel.toSeparatePorts(
      host: host,
      grpcPort: port,
      grpcTransportSecure: grpcTransportSecure,
      grpcWebPort: port,
      grpcWebTransportSecure: true,
    );
  }
}
