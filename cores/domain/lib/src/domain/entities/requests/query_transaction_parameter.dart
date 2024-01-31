enum QueryTransactionType{
  all,
  send,
  receive,
  executeContract,
  recovery,
}

final class QueryTransactionParameter {
  final int? heightLt;
  final int limit;
  final String environment;
  final List<String> msgTypes;
  final String? sender;
  final String? receive;
  final QueryTransactionType queryType;

  const QueryTransactionParameter({
    required this.limit,
    required this.heightLt,
    required this.environment,
    this.sender,
    required this.msgTypes,
    this.receive,
    this.queryType = QueryTransactionType.all,
  });

  Map<String, dynamic> toJson() {
    final Map<String,dynamic> json = {
      'operationName': 'QueryTxOfAccount',
      'query': '',
      'variables': {},
    };
    switch(queryType){
      case QueryTransactionType.send:
        json['variables'] = {
          "limit": limit,
          "sender": sender,
          "heightLT": heightLt,
          "listTxMsgType": msgTypes,
        };

        json['query'] = _querySend();
        break;
      case QueryTransactionType.receive:
        json['variables'] = {
          "limit": limit,
          "receiveAddress": receive,
          "heightLT": heightLt,
        };

        json['query'] = _queryReceive();
        break;
      case QueryTransactionType.executeContract:
        json['variables'] = {
          "limit": limit,
          "sender": sender,
          "heightLT": heightLt,
          "listTxMsgType": msgTypes,
        };
        json['query'] = _queryExecuteContract();
        break;
      case QueryTransactionType.recovery:
        json['variables'] = {
          "limit": limit,
          "sender": sender,
          "heightLT": heightLt,
          "listTxMsgType": msgTypes,
        };
        json['query'] = _queryRecoveryContract();
        break;
      case QueryTransactionType.all:
        json['variables'] = {
          "limit": limit,
          "receiveAddress": receive,
          "sender": sender,
          "heightLT": heightLt,
          "listTxMsgType": msgTypes,
        };

        json['query'] = _queryAll();
        break;
    }
    return json;
  }

  String _queryReceive() {
    const String query = r'''
      query QueryTxOfAccount($startTime: timestamptz = null, $endTime: timestamptz = null, $limit: Int = null,$heightGT: Int = null, $heightLT: Int = null, $orderHeight: order_by = desc, $receiveAddress: String = null) {
  ${environment} {
    transaction(
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, coin_transfers: {to: {_eq: $receiveAddress}, block_height: {_lt: $heightLT, _gt: $heightGT}, message: {type: {_in: null, _nin: null}}}}
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

  String _querySend(){
    const String query = r'''
    query QueryTxOfAccount($startTime: timestamptz = null, $endTime: timestamptz = null, $limit: Int = null, $listTxMsgType: [String!] = null, $listTxMsgTypeNotIn: [String!] = null, $heightGT: Int = null, $heightLT: Int = null, $orderHeight: order_by = desc, $sender: String = null) {
  ${environment} {
    transaction(
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, transaction_messages: {type: {_in: $listTxMsgType, _nin: $listTxMsgTypeNotIn}, sender: {_eq: $sender}}, _and: [{height: {_gt: $heightGT, _lt: $heightLT}}]}
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

  String _queryAll() {
    const String query = r'''
    query QueryTxOfAccount($startTime: timestamptz = null, $endTime: timestamptz = null, $limit: Int = null, $listTxMsgType: [String!] = null, $listTxMsgTypeNotIn: [String!] = null, $heightGT: Int = null, $heightLT: Int = null, $orderHeight: order_by = desc, $receiveAddress: String = null, $sender: String = null) {
  ${environment} {
    transaction(
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, _or: [{transaction_messages: {type: {_in: $listTxMsgType, _nin: $listTxMsgTypeNotIn}, sender: {_eq: $sender}}}, {coin_transfers: {_or: [{from: {_eq: $sender}}, {to: {_eq: $receiveAddress}}], block_height: {_lt: $heightLT, _gt: $heightLT}, message: {type: {_in: null, _nin: null}}}}], _and: [{height: {_gt: $heightGT, _lt: $heightLT}}]}
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

  String _queryExecuteContract(){
    const String query = r'''
    query QueryTxOfAccount($startTime: timestamptz = null, $endTime: timestamptz = null, $limit: Int = null, $listTxMsgType: [String!] = null, $listTxMsgTypeNotIn: [String!] = null, $heightGT: Int = null, $heightLT: Int = null, $orderHeight: order_by = desc, $sender: String = null) {
  ${environment} {
    transaction(
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, transaction_messages: {type: {_in: $listTxMsgType, _nin: $listTxMsgTypeNotIn}, sender: {_eq: $sender}}, _and: [{height: {_gt: $heightGT, _lt: $heightLT}}]}
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

  String _queryRecoveryContract(){
    const String query = r'''
    query QueryTxOfAccount($startTime: timestamptz = null, $endTime: timestamptz = null, $limit: Int = null, $listTxMsgType: [String!] = null, $listTxMsgTypeNotIn: [String!] = null, $heightGT: Int = null, $heightLT: Int = null, $orderHeight: order_by = desc, $sender: String = null) {
  ${environment} {
    transaction(
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, transaction_messages: {type: {_in: $listTxMsgType, _nin: $listTxMsgTypeNotIn}, sender: {_eq: $sender}}, _and: [{height: {_gt: $heightGT, _lt: $heightLT}}]}
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
