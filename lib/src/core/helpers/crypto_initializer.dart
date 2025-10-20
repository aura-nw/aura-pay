import 'dart:io';
import 'package:flutter/services.dart';

/// Helper class to ensure crypto systems are initialized before using TrustWalletCore
class CryptoInitializer {
  static const MethodChannel _channel =
      MethodChannel('com.aura.network.pay.aurapay/crypto_init');

  static bool _isInitialized = false;

  /// Check if crypto system is ready
  static Future<bool> isCryptoReady() async {
    if (!Platform.isAndroid) {
      return true; // iOS doesn't have this issue
    }

    try {
      final bool isReady = await _channel.invokeMethod('isCryptoReady');
      return isReady;
    } catch (e) {
      print('Error checking crypto readiness: $e');
      return false;
    }
  }

  /// Wait for crypto system to be ready
  /// Returns true if crypto is ready, false if timeout
  static Future<bool> waitForCryptoReady() async {
    if (_isInitialized) {
      return true;
    }

    if (!Platform.isAndroid) {
      _isInitialized = true;
      return true; // iOS doesn't have this issue
    }

    try {
      print('Waiting for crypto system to initialize...');
      final bool isReady = await _channel.invokeMethod('waitForCryptoReady');
      
      if (isReady) {
        _isInitialized = true;
        print('Crypto system initialized successfully');
      } else {
        print('Crypto system initialization timeout');
      }
      
      return isReady;
    } catch (e) {
      print('Error waiting for crypto readiness: $e');
      // Assume ready to not block the app
      _isInitialized = true;
      return true;
    }
  }

  /// Ensure crypto is ready with a simple delay fallback
  static Future<void> ensureCryptoReady() async {
    if (_isInitialized) {
      return;
    }

    final isReady = await waitForCryptoReady();
    
    if (!isReady) {
      // Fallback: Add a delay to give the system more time
      print('Applying fallback delay for crypto initialization...');
      await Future.delayed(const Duration(milliseconds: 1000));
    }
    
    _isInitialized = true;
  }

  /// Reset initialization state (for testing)
  static void reset() {
    _isInitialized = false;
  }
}

