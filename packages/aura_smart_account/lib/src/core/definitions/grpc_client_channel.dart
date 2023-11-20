import 'package:grpc/grpc_or_grpcweb.dart';

class GrpcClientChannel {
  final String host;
  final int port;
  final bool grpcTransportSecure;

  const GrpcClientChannel({
    required this.host,
    this.port = 9092,
    this.grpcTransportSecure = false,
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
