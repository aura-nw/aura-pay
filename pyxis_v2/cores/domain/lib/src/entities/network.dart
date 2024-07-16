import 'package:domain/core/enum.dart';

final class AppNetwork {
  final int id;
  final AppNetworkType type;
  final String rpc;
  final String symbol;
  final String denom;
  final bool isActive;

  const AppNetwork({
    required this.id,
    required this.type,
    required this.rpc,
    required this.symbol,
    required this.denom,
    this.isActive = false,
  });
}
