import 'dart:developer';

enum QueryTransactionType{
  send,
  receive,
  all,
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
    if(queryType.index == 0){
      json['variables'] = {
        "limit": limit,
        "sender": sender,
        "heightLT": heightLt,
        "listTxMsgType": msgTypes,
      };

      json['query'] = _querySend();
    }else if(queryType.index == 1){
      json['variables'] = {
        "limit": limit,
        "receiveAddress": receive,
        "heightLT": heightLt,
        "listTxMsgType": msgTypes,
      };

      json['query'] = _queryReceive();
    }else{
      json['variables'] = {
        "limit": limit,
        "receiveAddress": receive,
        "sender": sender,
        "heightLT": heightLt,
        "listTxMsgType": msgTypes,
      };

      json['query'] = _querySendAndReceive();
    }
    return json;
  }

  String _queryReceive() {
    const String query = r'''
      query QueryTxOfAccount($startTime: timestamptz = null, $endTime: timestamptz = null, $limit: Int = null, $listTxMsgType: [String!] = null, $listTxMsgTypeNotIn: [String!] = null, $heightGT: Int = null, $heightLT: Int = null, $orderHeight: order_by = desc, $receiveAddress: String = null) {
  ${environment} {
    transaction(
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, transaction_messages: {type: {_in: $listTxMsgType, _nin: $listTxMsgTypeNotIn}, transaction_message_receivers: {address: {_eq: $receiveAddress}}}, _and: [{height: {_gt: $heightGT, _lt: $heightLT}}]}
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
      where: {timestamp: {_lte: $endTime, _gte: $startTime}, transaction_messages: {type: {_in: $listTxMsgType, _nin: $listTxMsgTypeNotIn}, sender: {_eq:$sender}}, _and: [{height: {_gt: $heightGT, _lt: $heightLT}}]}
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

  String _querySendAndReceive() {
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
