# 🚀 Next Steps - Sau Khi Fix TrustWalletCore Crash

## ✅ Đã Hoàn Thành

1. ✅ Fix namespace error (Android Gradle Plugin 8.x)
2. ✅ Update minSdkVersion 24 → 26
3. ✅ Implement multi-layer TrustWalletCore crash fix
4. ✅ Add crypto initialization in MainActivity
5. ✅ Add CryptoInitializer helper class
6. ✅ Add delays and error handling

## 📋 Cần Làm Tiếp

### Bước 1: Build và Test (BẮT BUỘC)

```bash
# 1. Clean project
flutter clean
cd android && ./gradlew clean && cd ..

# 2. Get dependencies
flutter pub get

# 3. Build APK debug
flutter build apk --debug

# 4. Install to device
flutter install

# 5. Monitor logs khi test
adb logcat | grep -E "(MainActivity|GenerateWallet|TrustWallet|SIGSEGV)"
```

### Bước 2: Test Scenarios

Test các scenarios sau:

#### ✅ Test 1: Cold Start
1. Force stop app hoàn toàn
2. Mở app lại
3. Đợi 2-3 giây
4. Click "Generate Wallet"
5. **Expected:** Wallet được tạo thành công, không crash

#### ✅ Test 2: Immediate Generation
1. Mở app
2. **NGAY LẬP TỨC** click "Generate Wallet" (không đợi)
3. **Expected:** App đợi crypto init xong rồi mới generate

#### ✅ Test 3: Multiple Wallets
1. Generate wallet lần 1
2. Back ra
3. Generate wallet lần 2, 3, 4...
4. **Expected:** Tất cả đều thành công, không crash

#### ✅ Test 4: Low-end Device
1. Test trên device cũ/low-end (nếu có)
2. **Expected:** Vẫn work nhưng có thể chậm hơn

### Bước 3: Check Logs

Sau mỗi test, check logs để verify:

**✅ Logs thành công:**
```
D/MainActivity: Starting crypto initialization...
D/MainActivity: Crypto initialization completed successfully
I/flutter: [GenerateWallet] Ensuring crypto system is ready...
I/flutter: Waiting for crypto system to initialize...
I/flutter: Crypto system initialized successfully
I/flutter: [GenerateWallet] Crypto system ready, generating wallet...
I/flutter: [GenerateWallet] Mnemonic generated successfully
I/flutter: [GenerateWallet] Wallet imported successfully
```

**❌ Logs lỗi (nếu vẫn crash):**
```
F/libc: Fatal signal 11 (SIGSEGV)
# Hoặc
E/AndroidRuntime: FATAL EXCEPTION
```

### Bước 4: Nếu Vẫn Crash

Nếu sau khi implement tất cả fixes mà vẫn crash, thử các options sau:

#### Option A: Tăng Delay
Edit `lib/src/presentation/screens/generate_wallet/generate_wallet_cubit.dart`:
```dart
// Tăng từ 500ms lên 1000ms hoặc 2000ms
await Future.delayed(const Duration(milliseconds: 2000));
```

#### Option B: Sử Dụng Alternative Library
Thay TrustWalletCore bằng pure Dart implementation:

**pubspec.yaml:**
```yaml
dependencies:
  bip39: ^1.0.6  # Pure Dart BIP39
```

**Tạo file mới:** `lib/src/core/utils/mnemonic_generator_fallback.dart`
```dart
import 'package:bip39/bip39.dart' as bip39;

class MnemonicGeneratorFallback {
  static String generateMnemonic({int strength = 128}) {
    return bip39.generateMnemonic(strength: strength);
  }
}
```

Sau đó update `wallet_management.dart` để có fallback option.

#### Option C: Downgrade AGP (Temporary)
Nếu chỉ là để test nhanh, có thể downgrade Gradle Plugin:

**android/settings.gradle.kts:**
```kotlin
id("com.android.application") version "7.4.2" apply false
```

Và revert namespace fixes. Nhưng đây không phải long-term solution.

### Bước 5: Production Build

Sau khi test debug build OK:

```bash
# 1. Build release APK
flutter build apk --release

# 2. Hoặc build App Bundle
flutter build appbundle --release

# 3. Test release build trên device
adb install build/app/outputs/flutter-apk/app-release.apk
```

**⚠️ Lưu ý:** Release build có thể khác debug build về performance và crashes.

### Bước 6: Proguard Rules (Cho Release)

Nếu release build bị crash, thêm Proguard rules:

**android/app/proguard-rules.pro:**
```proguard
# Keep TrustWalletCore
-keep class wallet.core.** { *; }
-keep class com.trustwallet.** { *; }
-keepclassmembers class * {
    native <methods>;
}

# Keep Kotlin coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
```

**android/app/build.gradle.kts:**
```kotlin
buildTypes {
    release {
        isMinifyEnabled = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
        signingConfig = signingConfigs.getByName("debug")
    }
}
```

## 📊 Metrics Cần Monitor

Sau khi deploy:

1. **Crash Rate**: Monitor trên Firebase Crashlytics hoặc Sentry
2. **Wallet Generation Time**: Đo thời gian trung bình
3. **Success Rate**: % wallet generation thành công
4. **Device-specific Issues**: Check có devices nào bị crash nhiều hơn

## 🐛 Known Issues & Workarounds

### Issue 1: Delay Dài
**Symptom:** User phàn nàn wallet generation lâu (~2-3 giây)  
**Workaround:** 
- Thêm loading animation đẹp hơn
- Thêm progress text: "Initializing secure crypto..."
- Educate user: "Generating secure wallet..."

### Issue 2: Emulator vs Real Device
**Symptom:** Work trên emulator nhưng crash trên real device  
**Solution:** 
- Luôn test trên real device
- Different devices có entropy pool init speed khác nhau

### Issue 3: First Time vs Subsequent
**Symptom:** Lần đầu chậm, lần sau nhanh  
**Explanation:** Normal - entropy pool đã init sẵn

## 📞 Support

Nếu có vấn đề:

1. Check `TRUSTWALLETCORE_CRASH_FIX.md` - Detailed technical docs
2. Check `CRASH_FIX_SUMMARY_VI.md` - Summary tiếng Việt
3. Collect full logcat: `adb logcat > crash_log.txt`
4. Share crash_log.txt và device info

## ✅ Success Criteria

Fix được coi là thành công khi:

- [ ] No SIGSEGV crashes trong tests
- [ ] Wallet generation success rate > 99%
- [ ] Works trên ít nhất 3 different Android devices
- [ ] Works trên cả low-end và high-end devices
- [ ] Release build cũng stable như debug build
- [ ] User experience acceptable (delay < 5 giây)

---

**Good Luck! 🚀**

Nếu cần support thêm, ping team hoặc create issue với full logs.

