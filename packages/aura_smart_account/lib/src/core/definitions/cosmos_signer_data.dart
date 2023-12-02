import 'package:fixnum/fixnum.dart' as $fixnum;

final class CosmosSignerData {
  final String chainId;
  final $fixnum.Int64 accountNumber;
  final $fixnum.Int64 sequence;

  const CosmosSignerData({
    required this.chainId,
    required this.sequence,
    required this.accountNumber,
  });
}
