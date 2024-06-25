final class QueryNFTByAddressParameter {
  final String owner;
  final String environment;
  final int offset;
  final int limit;

  const QueryNFTByAddressParameter({
    required this.environment,
    required this.owner,
    this.offset = 0,
    this.limit = 20,
  });

  Map<String, dynamic> toJson() {
    return {
      'operationName': 'queryAssetCW721',
      'query': _query(),
      'variables': {
        "limit": limit,
        "offset": offset,
        "contract_address": null,
        "owner": owner
      },
    };
  }

  String _query() {
    String query = r'''
    query queryAssetCW721(
      $contract_address: String
      $limit: Int = 10
      $tokenId: String = null
      $owner: String = null
      $offset: Int = 0
    ) {
      ${environment} {
        cw721_token(
          limit: $limit
          offset: $offset
          where: {
            cw721_contract: {
              smart_contract: { address: { _eq: $contract_address }, name: {_neq: "crates.io:cw4973"} }
            }
            token_id: { _eq: $tokenId }
            owner: { _eq: $owner }
            burned: {_eq: false}
          }
          order_by: [{ last_updated_height: desc }, { id: desc }]
        ) {
          id
          token_id
          owner
          media_info
          last_updated_height
          created_at
          burned
          cw721_contract {
            name
            symbol
            smart_contract {
              name
              address
            }
          }
        }
        cw721_token_aggregate(where: {cw721_contract: {smart_contract: {address: {_eq: $contract_address}, name: {_neq: "crates.io:cw4973"}}}, token_id: {_eq: $tokenId}, owner: {_eq: $owner}, burned: {_eq: false}}, order_by: [{last_updated_height: desc}, {id: desc}]) {
          aggregate {
            count
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
