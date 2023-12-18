final class QueryTransactionParameter {
  final List<String> events;
  final int page;
  final int limit;

  const QueryTransactionParameter({
    required this.events,
    required this.limit,
    required this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      'events': events,
      'offset': page,
      'limit': limit,
    };
  }
}
