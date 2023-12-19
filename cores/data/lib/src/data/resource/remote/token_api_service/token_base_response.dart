class TokenBaseResponse<T> {
  final T data;

  const TokenBaseResponse({
    required this.data,
  });

  factory TokenBaseResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(Map<String, dynamic>) mapper,
  }) {
    T data = mapper(json);
    return TokenBaseResponse(
      data: data,
    );
  }
}
