import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';

sealed class LocalAuthHelper {
  static final LocalAuthentication _localAuthentication = LocalAuthentication();

  static Future<bool> canAuthenticateWithBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuthentication.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics ||
          await _localAuthentication.isDeviceSupported();

      return canAuthenticate;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> requestLocalAuth({
    String? localizedReason,
    String? androidSignTitle,
    String? cancelButton,
  }) async {
    androidSignTitle ??= AppLocalizationManager.instance.translate(
      LanguageKey.commonLocalAuthAndroidSignTitle,
    );
    localizedReason ??= AppLocalizationManager.instance.translate(
      LanguageKey.commonLocalAuthTitle,
    );
    cancelButton ??= AppLocalizationManager.instance.translate(
      LanguageKey.commonLocalAuthButtonCancelTitle,
    );
    try {
      return _localAuthentication.authenticate(
        localizedReason: localizedReason,
        authMessages: <AuthMessages>[
          AndroidAuthMessages(
            cancelButton: cancelButton,
            signInTitle: androidSignTitle,
          ),
          // IOSAuthMessages(
          //   cancelButton: cancelButton,
          // ),
        ],
        options: const AuthenticationOptions(),
      );
    } catch (e) {
      return false;
    }
  }
}
