final class TransactionBaseResponse {
  final List<Map<String, dynamic>> txs;
  final List<Map<String, dynamic>> txResponse;

  const TransactionBaseResponse({
    required this.txs,
    required this.txResponse,
  });

  factory TransactionBaseResponse.fromJson(Map<String, dynamic> json) {
    return TransactionBaseResponse(
      txs: ((json['txs'] ?? []) as List<dynamic>).map((e) => Map<String,dynamic>.from(e)).toList(),
      txResponse: ((json['tx_responses'] ?? []) as List<dynamic>).map((e) => Map<String,dynamic>.from(e)).toList(),
    );
  }
}
