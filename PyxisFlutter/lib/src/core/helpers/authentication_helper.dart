import 'dart:convert';
import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:domain/domain.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/device.dart';

/// Represents the parameters required for authentication, including signature,
/// public key, device ID, and Unix timestamp.
final class AuthParameter {
  final String signature;
  final String pubKey;
  final String deviceId;
  final String unixTimestamp;

  const AuthParameter({
    required this.signature,
    required this.pubKey,
    required this.deviceId,
    required this.unixTimestamp,
  });

  AuthParameter copyWith({
    String? signature,
    String? pubKey,
    String? deviceId,
    String? unixTimestamp,
  }) {
    return AuthParameter(
      signature: signature ?? this.signature,
      pubKey: pubKey ?? this.pubKey,
      deviceId: deviceId ?? this.deviceId,
      unixTimestamp: unixTimestamp ?? this.unixTimestamp,
    );
  }
}

/// Helper class for authentication-related operations.
sealed class AuthHelper {
  static const String _alReadyRegister = 'E009';

  /// Generates authentication parameters, including signature, public key,
  /// device ID, and Unix timestamp using the provided key pair.
  static Future<AuthParameter> _generateAuthParameter({
    required dynamic keyPair,
  }) async {
    // Get device id
    final String deviceId = await DeviceHelper.getDeviceId();

    // Current date time
    DateTime now = DateTime.now();

    // Convert to Unix timestamp (in seconds)
    int unixTimestamp = now.millisecondsSinceEpoch ~/ 1000;

    final String unixTimestampString = unixTimestamp.toString();

    // create signature bytes
    final Uint8List signatureBytes = CryptoUtil.createSignature(
      message: unixTimestampString,
      privateKey: keyPair.privateKey,
      seed: deviceId,
    );

    // Convert signature bytes to base64
    final String signature = base64Encode(signatureBytes);

    return AuthParameter(
      signature: signature,
      pubKey: '',
      deviceId: deviceId,
      unixTimestamp: unixTimestampString,
    );
  }

  /// Generates authentication parameters for registration using the provided private key.
  static Future<AuthParameter> generateRegisterParameter({
    required Uint8List privateKey,
  }) async {
    final keyPair = CryptoUtil.generateKeyPairByPrivateKey(privateKey);

    // Generate parameter from keypair
    final AuthParameter parameter = await _generateAuthParameter(
      keyPair: keyPair,
    );

    // Generate public key by key pair
    final Uint8List publicKey = CryptoUtil.getPublicKeyByKeyPair(keyPair);

    final String pubKeyString = base64Encode(publicKey);

    return parameter.copyWith(
      pubKey: pubKeyString,
    );
  }

  /// Generates authentication parameters for sign-in using the provided private key.
  static Future<AuthParameter> generateSignInParameter({
    required Uint8List privateKey,
  }) async {
    final keyPair = CryptoUtil.generateKeyPairByPrivateKey(privateKey);
    return _generateAuthParameter(
      keyPair: keyPair,
    );
  }

  /// Removes the current access token and associated public key for the specified wallet address.
  ///
  /// This method retrieves the current public key using the provided [AuthUseCase],
  /// removes both the public key and its associated access token, if available.
  ///
  /// Parameters:
  /// - [authUseCase]: An instance of [AuthUseCase] for accessing authentication-related functionality.
  /// - [walletAddress]: The wallet address for which to remove the current access token.
  static Future<void> removeCurrentToken({
    required AuthUseCase authUseCase,
    required String walletAddress,
  }) async {
    // Remove the access token
    await authUseCase.removeCurrentAccessToken(
      key: createAccessTokenKey(
        walletAddress: walletAddress,
      ),
    );
  }

  /// Saves the access token associated with the specified wallet address using the provided [AuthUseCase].
  static Future<void> saveTokenByWalletAddress({
    required AuthUseCase authUseCase,
    required String walletAddress,
    required String accessToken,
  }) async {
    return authUseCase.saveAccessToken(
      key: createAccessTokenKey(
        walletAddress: walletAddress,
      ),
      accessToken: accessToken,
    );
  }

  /// Retrieves the current access token associated with the specified wallet address.
  ///
  /// This method retrieves the current public key using the provided [AuthUseCase], and then
  /// retrieves the access token associated with that public key.
  ///
  /// Parameters:
  /// - [walletAddress]: The wallet address for which to retrieve the current access token.
  /// - [authUseCase]: An instance of [AuthUseCase] for accessing authentication-related functionality.
  ///
  /// Returns:
  /// - The current access token if available; otherwise, returns null.
  static Future<String?> getCurrentToken({
    required AuthUseCase authUseCase,
    required String walletAddress,
  }) async {
    return await authUseCase.getCurrentAccessToken(
      key: createAccessTokenKey(
        walletAddress: walletAddress,
      ),
    );
  }

  /// Handles device registration or sign-in using the provided DeviceManagementUseCase,
  /// AuthUseCase, and private key. It generates authentication parameters for registration,
  /// attempts to register the device, and handles exceptions. If the device is already
  /// registered, it falls back to signing in.
  /// Parameters:
  /// - `deviceManagementUseCase`: An instance of DeviceManagementUseCase for managing devices.
  /// - `authUseCase`: An instance of AuthUseCase for handling authentication.
  /// - `privateKey`: A Uint8List representing the private key used for authentication.
  static Future<String> registerOrSignIn({
    required DeviceManagementUseCase deviceManagementUseCase,
    required AuthUseCase authUseCase,
    required Uint8List privateKey,
  }) async {
    // Generate authentication parameters for registration using the provided private key
    final AuthParameter parameter = await generateRegisterParameter(
      privateKey: privateKey,
    );

    try {
      // Attempt to register the device
      return deviceManagementUseCase.registerDevice(
        pubKey: parameter.pubKey,
        deviceId: parameter.deviceId,
        signature: parameter.signature,
        unixTimestamp: parameter.unixTimestamp,
      );
    } catch (e) {
      // Handle registration exceptions
      if (e is AppError) {
        // Check if the device is already registered
        if (e.code == _alReadyRegister) {
          // If the device is already registered, attempt to sign in
          return await authUseCase.signIn(
            deviceId: parameter.deviceId,
            signature: parameter.signature,
            unixTimestamp: parameter.unixTimestamp,
          );
        }
      }
      // Re-throw other exceptions for higher-level handling
      rethrow;
    }
  }

  /// Signs in a user using the provided authentication and device management use cases,
  /// private key, and wallet address. The method first attempts to retrieve the current
  /// access token associated with the wallet address. If a token exists, it generates
  /// authentication parameters and delegates the sign-in process to the AuthUseCase.
  /// If no current access token is found, it proceeds to perform registration or sign-in.
  /// Parameters:
  /// - `authUseCase`: An instance of the AuthUseCase for handling authentication.
  /// - `deviceManagementUseCase`: An instance of the DeviceManagementUseCase for managing devices.
  /// - `privateKey`: A Uint8List representing the private key used for authentication.
  /// - `walletAddress`: The wallet address associated with the user.
  static Future<String> signIn({
    required AuthUseCase authUseCase,
    required DeviceManagementUseCase deviceManagementUseCase,
    required Uint8List privateKey,
    required String walletAddress,
  }) async {
    // Retrieve the current access token associated with the wallet address
    final String? currentAccessToken = await authUseCase.getCurrentAccessToken(
      key: createAccessTokenKey(
        walletAddress: walletAddress,
      ),
    );

    if (currentAccessToken != null) {
      // Generate authentication parameters for sign-in using the provided private key
      final AuthParameter parameter = await generateSignInParameter(
        privateKey: privateKey,
      );

      // Delegate the sign-in process to the AuthUseCase, passing generated parameters
      return authUseCase.signIn(
        deviceId: parameter.deviceId,
        unixTimestamp: parameter.unixTimestamp,
        signature: parameter.signature,
      );
    }

    // If no current access token is found, perform registration or sign-in
    return registerOrSignIn(
      deviceManagementUseCase: deviceManagementUseCase,
      authUseCase: authUseCase,
      privateKey: privateKey,
    );
  }

  /// Creates the key for accessing the current access token based on the provided wallet address.
  static String createAccessTokenKey({
    required String walletAddress,
  }) {
    return AppLocalConstant.currentAccessToken + walletAddress;
  }
}
