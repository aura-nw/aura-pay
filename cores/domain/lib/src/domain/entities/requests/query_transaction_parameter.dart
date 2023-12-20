final class QueryTransactionParameter {
  final int? heightLt;
  final int limit;
  final String environment;
  final List<String> msgTypes;
  final String ?sender;
  final String? receive;

  const QueryTransactionParameter({
    required this.limit,
    required this.heightLt,
    required this.environment,
    this.sender,
    required this.msgTypes,
    this.receive,
  });

  Map<String, dynamic> toJson() {
    return {
      'operationName': 'QueryTxOfAccount',
      'query': _query(),
      'variables': {
        "limit": limit,
        "receiveAddress": receive,
        "sender": sender,
        "heightLT": heightLt,
        "listTxMsgType": msgTypes,
      },
    };
  }

  String _query() {
    const String query = r'''
    query QueryTxOfAccount($startTime: timestamptz = null, $endTime: timestamptz = null, $limit: Int = null, $listTxMsgType: [String!] = null, $listTxMsgTypeNotIn: [String!] = null, $heightGT: Int = null, $heightLT: Int = null, $orderHeight: order_by = desc, $receiveAddress: String = null , $sender: String = null) {
  ${environment} {
    transaction(
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, transaction_messages: {type: {_in: $listTxMsgType, _nin: $listTxMsgTypeNotIn}, _and: {_or: [{ sender: { _eq: $sender}}, {transaction_message_receivers: { address: {_eq: $receiveAddress}}}]}}, _and: [{height: {_gt: $heightGT, _lt: $heightLT}}]}
      limit: $limit
      order_by: {height: $orderHeight}
    ) {
      hash
      height
      fee
      timestamp
      code
      transaction_messages {
        type
        content
      }
    }
  }
}
    ''';

    return query.replaceFirst(
      '\${environment}',
      environment,
    );
  }
}
