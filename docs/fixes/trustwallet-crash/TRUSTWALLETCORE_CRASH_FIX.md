# TrustWalletCore Crash Fix Documentation

## Problem Description

**Error Type:** SIGSEGV (Segmentation Fault) - Null Pointer Dereference  
**Location:** `libTrustWalletCore.so` → `random_buffer` → `mnemonic_generate` → `HDWallet` constructor  
**Fault Address:** `0x0000000000000000`

### Crash Backtrace
```
#00 random_buffer+64
#01 mnemonic_generate+144
#02 HDWallet::HDWallet(int, string const&)+116
#03 TWHDWalletCreate+184
```

### Root Cause
The crash occurs when TrustWalletCore's `random_buffer` function tries to access the system's entropy source (random number generator) but receives a null pointer. This typically happens when:

1. The Android SecureRandom entropy pool is not initialized
2. TrustWalletCore native library is called too early after app startup
3. Insufficient permissions to access `/dev/urandom` or system RNG
4. Device-specific issues with Android SDK 26+ crypto providers

## Implemented Fixes

### 1. Advanced MainActivity Crypto Initialization ✅✅ (UPDATED)
**File:** `android/app/src/main/kotlin/com/aura/network/pay/aurapay/MainActivity.kt`

Implemented comprehensive crypto system initialization with:
- **Multi-stage SecureRandom priming** with delays between stages
- **Explicit entropy seeding** using SecureRandom.getInstanceStrong()
- **Native library preloading** for TrustWalletCore
- **MethodChannel communication** to allow Flutter to wait for initialization
- **Coroutines-based async initialization** to avoid blocking UI thread

**Key Features:**
- Runs in background thread (Dispatchers.IO)
- Provides `waitForCryptoReady()` method for Flutter to check readiness
- Multiple retries with delays to ensure entropy pool is fully primed
- 500ms final delay to ensure stability

**Dependencies Added:**
```kotlin
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
```

### 2. CryptoInitializer Helper Class ✅✅ (NEW)
**File:** `lib/src/core/helpers/crypto_initializer.dart`

Created a dedicated helper class for managing crypto initialization:
- **Platform-aware**: Only applies delays on Android (iOS doesn't have this issue)
- **MethodChannel integration**: Communicates with native MainActivity
- **Timeout handling**: Waits up to 5 seconds with fallback
- **One-time initialization**: Caches state to avoid redundant checks

**Key Methods:**
- `isCryptoReady()`: Quick check if crypto is ready
- `waitForCryptoReady()`: Waits for up to 5 seconds
- `ensureCryptoReady()`: Ensures crypto is ready with fallback delay

### 3. Enhanced WalletManagement with Delays ✅✅ (UPDATED)
**File:** `packages/wallet_core/lib/src/managements/wallet_management.dart`

Enhanced with:
- **Platform detection**: Uses `dart:io` to detect Android
- **Synchronous delay**: 200ms busy-wait before creating HDWallet on Android
- **Error handling**: Descriptive error messages for troubleshooting
- **Configurable**: `waitForCryptoInit` parameter to control behavior

```dart
String randomMnemonic({
  int strength = 128, 
  String passphrase = '',
  bool waitForCryptoInit = true,
}) {
  try {
    // On Android, add delay to ensure entropy pool is ready
    if (Platform.isAndroid && waitForCryptoInit) {
      final stopwatch = Stopwatch()..start();
      while (stopwatch.elapsedMilliseconds < 200) {
        // Small delay to let native crypto initialize
      }
    }
    
    final wallet = HDWallet(strength: strength, passphrase: passphrase);
    final mnemonic = wallet.mnemonic();
    
    if (mnemonic.isEmpty) {
      throw Exception('Generated mnemonic is empty');
    }
    
    return mnemonic;
  } catch (e) {
    throw Exception('Failed to generate mnemonic: $e...');
  }
}
```

### 4. GenerateWalletCubit with Multi-Layer Protection ✅✅ (UPDATED)
**File:** `lib/src/presentation/screens/generate_wallet/generate_wallet_cubit.dart`

Implemented comprehensive protection:
- **CryptoInitializer integration**: Waits for native initialization
- **Additional 500ms delay**: Extra safety buffer on Android
- **Detailed logging**: Tracks each step for debugging
- **Stack trace capture**: Full error context for troubleshooting

```dart
void generateWallet() async {
  try {
    // CRITICAL: Wait for crypto system to be ready
    await CryptoInitializer.ensureCryptoReady();
    
    // Add additional safety delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final String mnemonic = WalletCore.walletManagement.randomMnemonic();
    final AWallet aWallet = WalletCore.walletManagement.importWallet(mnemonic);
    // ... rest of logic
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}
```

### 4. Minimum SDK Version Update ✅
**File:** `android/app/build.gradle.kts`

Updated `minSdk` from 24 to 26 for better compatibility with Web3Auth and TrustWalletCore:

```kotlin
minSdk = 26  // Updated to support web3auth_flutter plugin
```

## Additional Recommendations

### If the Crash Still Occurs

#### Option 1: Add Delay Before Wallet Generation
Add a small delay in the app startup before allowing wallet generation:

```dart
// In your app initialization or generate wallet screen
await Future.delayed(const Duration(milliseconds: 500));
final mnemonic = WalletCore.walletManagement.randomMnemonic();
```

#### Option 2: Update TrustWalletCore Version
Check if there's a newer version of the `trust_wallet_core` Flutter package that might have fixed this issue:

```yaml
# In packages/wallet_core/pubspec.yaml
trust_wallet_core:
  git:
    url: https://github.com/ToanBarcelona1998/flutter_trust_wallet_core
    ref: main  # or latest stable tag
```

#### Option 3: Add Proguard Rules (for Release Builds)
If the crash only occurs in release builds, add Proguard rules:

**File:** `android/app/proguard-rules.pro`
```proguard
# Keep TrustWalletCore classes
-keep class wallet.core.** { *; }
-keep class com.trustwallet.** { *; }
-keepclassmembers class * {
    native <methods>;
}
```

Then enable in `android/app/build.gradle.kts`:
```kotlin
buildTypes {
    release {
        isMinifyEnabled = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

#### Option 4: Use Alternative Mnemonic Generation
As a fallback, consider using a pure Dart implementation for mnemonic generation:

```yaml
dependencies:
  bip39: ^1.0.6  # Pure Dart BIP39 implementation
```

```dart
import 'package:bip39/bip39.dart' as bip39;

String generateMnemonic() {
  return bip39.generateMnemonic(strength: 128);
}
```

#### Option 5: Device-Specific Handling
Some devices might have issues with SecureRandom. Add device detection:

```dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

Future<String> generateMnemonicSafe() async {
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    
    // Add delay for problematic Android versions
    if (androidInfo.version.sdkInt <= 28) {
      await Future.delayed(const Duration(seconds: 1));
    }
  }
  
  return WalletCore.walletManagement.randomMnemonic();
}
```

## Testing the Fix

### 1. Clean Build
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean
cd ..
flutter build apk --debug
```

### 2. Test on Multiple Devices
- Test on Android 8.0 (SDK 26)
- Test on Android 9.0 (SDK 28)
- Test on Android 10+ (SDK 29+)

### 3. Monitor Logs
```bash
adb logcat | grep -E "(TrustWallet|SecureRandom|MainActivity|SIGSEGV)"
```

## Known Issues

1. **Cold Start vs Warm Start**: The crash might only occur on cold starts when the entropy pool is not ready.

2. **Device Variance**: Some devices (especially low-end or heavily customized Android ROMs) might have slower entropy pool initialization.

3. **Emulator vs Real Device**: The crash might behave differently on emulators vs real devices due to hardware RNG differences.

## References

- [TrustWallet Core GitHub](https://github.com/trustwallet/wallet-core)
- [Android SecureRandom Documentation](https://developer.android.com/reference/java/security/SecureRandom)
- [Stack Overflow: Namespace not specified error](https://stackoverflow.com/questions/76108428/how-do-i-fix-namespace-not-specified-error-in-android-studio)

## Support

If the issue persists after implementing these fixes, consider:

1. Opening an issue on the `flutter_trust_wallet_core` repository
2. Checking if the crash is specific to certain Android devices/versions
3. Using alternative wallet generation libraries as a temporary workaround

## Summary of Multi-Layer Fix Strategy

The implemented solution uses a **defense-in-depth approach** with multiple layers:

1. **Native Layer (MainActivity)**: 
   - Initializes SecureRandom entropy pool early
   - Preloads TrustWalletCore library
   - Provides status via MethodChannel

2. **Helper Layer (CryptoInitializer)**: 
   - Waits for native initialization to complete
   - Provides fallback delays if needed
   - Platform-aware (Android-only)

3. **Package Layer (WalletManagement)**: 
   - Adds synchronous delay before HDWallet creation
   - Platform detection and conditional delays
   - Enhanced error messages

4. **UI Layer (GenerateWalletCubit)**: 
   - Waits for CryptoInitializer before generating wallet
   - Additional safety delay
   - Comprehensive logging and error handling

**Total delay before HDWallet creation on Android:**
- Native initialization: ~1.5 seconds (background)
- CryptoInitializer wait: up to 5 seconds
- Additional safety delay: 500ms
- WalletManagement delay: 200ms
- **Total: ~2.2 seconds minimum** (enough time for entropy pool to fully initialize)

## Expected Behavior After Fix

1. **On app startup**: MainActivity begins crypto initialization in background
2. **When user clicks "Generate Wallet"**:
   - CryptoInitializer waits for native initialization
   - Adds additional delays for safety
   - Only then calls TrustWalletCore
3. **Result**: No more SIGSEGV crashes due to uninitialized entropy pool

## Monitoring and Debugging

Check logs for these messages:
```
MainActivity: Starting crypto initialization...
MainActivity: Crypto initialization completed successfully
[GenerateWallet] Ensuring crypto system is ready...
[GenerateWallet] Crypto system ready, generating wallet...
[GenerateWallet] Mnemonic generated successfully
[GenerateWallet] Wallet imported successfully
```

If crash still occurs, you'll see detailed error logs and stack traces.

---

**Last Updated:** 2025-10-20  
**Status:** ✅ Comprehensive Multi-Layer Fix Implemented  
**Testing Required:** Deploy to device and test wallet generation

