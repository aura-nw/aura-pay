class AppError {
  final String code;
  final String ?message;

  const AppError({
    required this.code,
    this.message,
  });

  @override
  String toString() {
    return 'App error [$code] $message';
  }
}