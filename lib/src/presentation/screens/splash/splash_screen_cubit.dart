import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/device.dart';
import 'package:pyxis_mobile/src/core/helpers/local_auth_helper.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final AppSecureUseCase _appSecureUseCase;
  final AuraAccountUseCase _accountUseCase;
  final AuthUseCase _authUseCase;

  SplashScreenCubit(
    this._appSecureUseCase,
    this._accountUseCase,
    this._authUseCase,
  ) : super(
          const SplashScreenState(),
        );

  Future<void> starting() async {
    emit(state.copyWith(
      status: SplashScreenStatus.starting,
    ));

    try {
      // final String deviceId = await DeviceHelper.getDeviceId();
      //
      // // Get the current time
      // DateTime now = DateTime.now();
      //
      // // Calculate one month from now
      // DateTime oneMonthFromNow = now.add(
      //   const Duration(
      //     days: 30,
      //   ),
      // );
      //
      // // Convert the DateTime object to a Unix timestamp (in milliseconds)
      // int unixTimestampMillis = oneMonthFromNow.millisecondsSinceEpoch;
      //
      // // Convert to Unix timestamp in seconds
      // int unixTimestampSeconds = unixTimestampMillis ~/ 1000;
      //
      // // Generate keypair with device id
      // final keyPair = CryptoUtil.createKeyPair(
      //   seed: deviceId,
      // );
      // // print(base64Encode(privateKey));
      // // // print(PointyCastleHelper.bytesToHex(privateKey));
      // //
      // final Uint8List publicKey = keyPair.publicKey.Q!.getEncoded(true);
      //
      // print('publicKey bytes = ${publicKey}');
      //
      // print(base64Encode(publicKey));
      // // print(PointyCastleHelper.bytesToHex(publicKey));
      //
      // print('msg = ${utf8.encode(unixTimestampSeconds.toString())}');
      // // Create signature
      // final String signature = PointyCastleHelper.createSignature(
      //   unixTimestampSeconds.toString(),
      //   deviceId,
      //   keyPair.privateKey,
      // );
      //
      // print('signature = ${signature}');
      // //
      // // print(base64Encode(signature));
      //
      // // print(PointyCastleHelper.bytesToHex(signature));
      //
      // print(unixTimestampSeconds);
      // print(deviceId);
      //
      // // await _authUseCase.signIn(
      // //   deviceId: deviceId,
      // //   unixTimestamp: unixTimestampSeconds.toString(),
      // //   signature: WalletHelper.bytesToHex(
      // //     signature,
      // //   ),
      // // );

      // Default status
      SplashScreenStatus status = SplashScreenStatus.notHasPassCodeOrError;

      final bool hasPassCode = await _appSecureUseCase.hasPassCode(
        key: AppLocalConstant.passCodeKey,
      );

      if (hasPassCode) {
        // if user set biometric. Check authentication by biometric. If user does not allow

        // user has passcode
        status = SplashScreenStatus.hasPassCode;

        // check user set biometric
        final bool isReadySetAuthenticationByBiometric =
            await _appSecureUseCase.alReadySetBioMetric(
          key: AppLocalConstant.bioMetricKey,
        );

        // user has set biometric
        if (isReadySetAuthenticationByBiometric) {
          // check device can use bio
          final bool isSupportBio =
              await LocalAuthHelper.canAuthenticateWithBiometrics();

          // this device support biometric
          if (isSupportBio) {
            bool isVerify = await LocalAuthHelper.requestLocalAuth();

            final account = await _accountUseCase.getFirstAccount();

            // users verify successful
            if (isVerify && account != null) {
              status = SplashScreenStatus.verifyByBioSuccessful;
            }
          }
        }
      }

      emit(
        state.copyWith(status: status),
      );
    } catch (e) {
      emit(state.copyWith(
        status: SplashScreenStatus.notHasPassCodeOrError,
      ));
    }
  }
}
