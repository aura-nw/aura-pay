final class QueryBalancesParameter {
  final String address;
  final String environment;

  const QueryBalancesParameter({
    required this.address,
    required this.environment,
  });

  Map<String, dynamic> toJson() {
    return {
      'operationName': 'VALIDATOR_ACCOUNT_TEMPLATE',
      'query': _query(),
      'variables': {
        "account_address": address,
      },
    };
  }

  String _query() {
    const String query = r'''
    query VALIDATOR_ACCOUNT_TEMPLATE($account_address: String = "") {
    ${environment} {
      account(where: {address: {_eq: $account_address}}) {
        balances
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
