final class QueryTokenMarketParameter {
  final bool onlyIbc;

  const QueryTokenMarketParameter({
    this.onlyIbc = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'onlyIbc': onlyIbc,
    };
  }
}
