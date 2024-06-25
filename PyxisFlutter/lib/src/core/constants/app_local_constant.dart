sealed class AppLocalConstant{
  // account db name
  static const String accountDbName = 'auth.isar';

  // this db name save private key or passPhrase
  static const String keyDbName = 'pyxis_controller_key_db_name';
  static const String keyDbPrefix = 'pyxis_controller_key_db_prefix';
  static const String keyStoreAlias = 'pyxis_controller_key_store_alias';


  // Passcode and biometric key
  static const String passCodeKey = 'pyxis_app_pass_code';
  static const String bioMetricKey = 'pyxis_app_bio_metric';

  static const String currentAccessToken = '/pyxis_access_token/';
}