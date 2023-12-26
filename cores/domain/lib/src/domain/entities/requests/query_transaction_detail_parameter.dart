final class QueryTransactionDetailParameter {
  final String environment;
  final String txHash;

  const QueryTransactionDetailParameter({
    required this.environment,
    required this.txHash,
  });

  Map<String, dynamic> toJson() {
    return {
      'variables': {
        'limit': 1,
        'order': 'desc',
        'hash': txHash,
        'heightGT': null,
        'indexGT': null,
        'indexLT': null,
        'height': null,
      },
      'query': _query(),
      'operationName': 'queryTxDetail',
    };
  }

  String _query() {
    String query = r'''
    
    query queryTxDetail(
      $limit: Int = 100
      $order: order_by = desc
      $heightGT: Int = null
      $heightLT: Int = null
      $indexGT: Int = null
      $indexLT: Int = null
      $hash: String = null
      $height: Int = null
    ) {
      ${environment} {
        transaction(
          limit: $limit
          where: {
            hash: { _eq: $hash }
            height: { _eq: $height }
            _and: [
              { height: { _gt: $heightGT } }
              { index: { _gt: $indexGT } }
              { height: { _lt: $heightLT } }
              { index: { _lt: $indexLT } }
            ]
          }
          order_by: [{ height: $order}, {index: $order }]
        ) {
          id
          height
          hash
          timestamp
          code
          gas_used
          gas_wanted
          data
          memo
        }
      }
    }
    
    ''';

    return query.replaceFirst('\${environment}', environment);
  }
}
