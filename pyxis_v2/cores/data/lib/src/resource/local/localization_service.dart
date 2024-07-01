abstract interface class LocalizationService{
  Future<List<String>> getSupportLocale();

  Future<Map<String, String>> getLocalLanguage({
    required String locale,
  });
}