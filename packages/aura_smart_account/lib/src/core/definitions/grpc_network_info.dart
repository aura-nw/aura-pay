import 'package:grpc/grpc_or_grpcweb.dart';

class AuraNetworkInfo {
  final String host;
  final int port;
  final bool grpcTransportSecure;
  final String chainId;
  final String bech32Hrp;
  final String denom;

  const AuraNetworkInfo({
    required this.host,
    this.port = 9092,
    this.grpcTransportSecure = false,
    required this.chainId,
    required this.bech32Hrp,
    required this.denom,
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
