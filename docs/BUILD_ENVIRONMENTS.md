# 🚀 Build Environments Guide

Hướng dẫn build app với các environments khác nhau sử dụng `--dart-define`.

---

## 📋 Các Environments Có Sẵn

| Environment | Tên | Config File | Mô tả |
|-------------|-----|-------------|-------|
| **Development** | `development`, `dev`, `serenity` | `config.dev.json` | Môi trường phát triển (Aura Serenity) |
| **Staging** | `staging` | `config.staging.json` | Môi trường staging/testing (Aura Euphoria) |
| **Production** | `production` | `config.json` | Môi trường production (Aura EVM) |

---

## 🏃 Chạy App (Development)

### Development (Default)
```bash
# Nếu không set ENV, mặc định là development
flutter run

# Hoặc explicit set environment
flutter run --dart-define=ENV=development
```

### Staging
```bash
flutter run --dart-define=ENV=staging
```

### Production
```bash
flutter run --dart-define=ENV=production
```

---

## 📦 Build APK (Android)

### Development
```bash
flutter build apk --dart-define=ENV=development
```

### Staging
```bash
flutter build apk --dart-define=ENV=staging
```

### Production
```bash
flutter build apk --dart-define=ENV=production --release
```

### Build App Bundle (cho Google Play)
```bash
flutter build appbundle --dart-define=ENV=production --release
```

---

## 🍎 Build iOS

### Development
```bash
flutter build ios --dart-define=ENV=development
```

### Staging
```bash
flutter build ios --dart-define=ENV=staging
```

### Production
```bash
flutter build ios --dart-define=ENV=production --release
```

### Build IPA
```bash
flutter build ipa --dart-define=ENV=production --release
```

---

## 🔨 Build Scripts

Để tiện lợi hơn, bạn có thể tạo các scripts:

### Linux/macOS

Tạo file `scripts/build.sh`:

```bash
#!/bin/bash

ENV=${1:-development}
PLATFORM=${2:-android}

echo "Building for $ENV on $PLATFORM..."

if [ "$PLATFORM" = "android" ]; then
    flutter build apk --dart-define=ENV=$ENV
elif [ "$PLATFORM" = "ios" ]; then
    flutter build ios --dart-define=ENV=$ENV
else
    echo "Invalid platform. Use 'android' or 'ios'"
    exit 1
fi
```

Sử dụng:
```bash
chmod +x scripts/build.sh
./scripts/build.sh production android
./scripts/build.sh staging ios
```

### Windows (PowerShell)

Tạo file `scripts/build.ps1`:

```powershell
param(
    [string]$Env = "development",
    [string]$Platform = "android"
)

Write-Host "Building for $Env on $Platform..."

if ($Platform -eq "android") {
    flutter build apk --dart-define=ENV=$Env
} elseif ($Platform -eq "ios") {
    flutter build ios --dart-define=ENV=$Env
} else {
    Write-Host "Invalid platform. Use 'android' or 'ios'"
    exit 1
}
```

Sử dụng:
```powershell
.\scripts\build.ps1 -Env production -Platform android
.\scripts\build.ps1 -Env staging -Platform ios
```

---

## 🎯 VS Code Launch Configuration

Thêm vào `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=ENV=development"
      ]
    },
    {
      "name": "Staging",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=ENV=staging"
      ]
    },
    {
      "name": "Production",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=ENV=production"
      ]
    }
  ]
}
```

Sau đó có thể chọn environment từ VS Code debugger dropdown.

---

## 🔍 Kiểm Tra Environment Hiện Tại

App sẽ in ra environment info khi start:

```
================================
Environment Configuration
================================
Environment: production
Is Production: true
Is Staging: false
Is Development: false
================================
```

Bạn cũng có thể check trong code:

```dart
import 'package:aurapay/app_configs/environment_config.dart';

// Check environment
if (EnvironmentConfig.isProduction) {
  // Production-specific code
}

if (EnvironmentConfig.isDevelopment) {
  // Development-specific code
}

// Get environment name
final envName = EnvironmentConfig.environmentName;
print('Running on: $envName');
```

---

## 🐛 Troubleshooting

### Issue: App vẫn dùng environment cũ

**Solution:** Clean build cache
```bash
flutter clean
flutter pub get
flutter run --dart-define=ENV=production
```

### Issue: Config file không tìm thấy

**Solution:** Kiểm tra files trong `assets/config/`:
- `config.dev.json` (Development)
- `config.staging.json` (Staging)
- `config.json` (Production)

Ensure chúng được declare trong `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/config/
```

### Issue: Environment không được set đúng

**Solution:** Check log output khi app start. Phải thấy:
```
================================
Environment Configuration
================================
Environment: <your-env>
...
```

---

## 📝 Best Practices

1. **Không commit build artifacts** - Add vào `.gitignore`:
   ```
   build/
   *.apk
   *.aab
   *.ipa
   ```

2. **Always test trước khi build production**:
   ```bash
   # Test với production config
   flutter run --dart-define=ENV=production
   
   # Nếu OK, build
   flutter build apk --dart-define=ENV=production --release
   ```

3. **Use consistent naming**:
   - Development: `aurapay-dev-v1.0.0.apk`
   - Staging: `aurapay-staging-v1.0.0.apk`
   - Production: `aurapay-v1.0.0.apk`

4. **Version management**:
   ```bash
   # Update version trong pubspec.yaml trước khi build
   version: 1.0.0+1
   ```

---

## 🔐 Security Notes

- **KHÔNG BAO GIỜ** commit sensitive data trong config files
- Config files nên chứa:
  - ✅ API endpoints
  - ✅ Public configuration
  - ❌ API keys (use environment variables hoặc secure storage)
  - ❌ Private keys
  - ❌ Secrets

- Cho production, consider sử dụng:
  - Flutter Secure Storage cho sensitive data
  - Remote config (Firebase Remote Config)
  - Environment variables cho CI/CD

---

## 🚀 CI/CD Integration

### GitHub Actions Example

```yaml
name: Build Android APK

on:
  push:
    branches: [ main, develop ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build Development APK
        run: flutter build apk --dart-define=ENV=development
      
      - name: Build Production APK
        if: github.ref == 'refs/heads/main'
        run: flutter build apk --dart-define=ENV=production --release
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: apk-builds
          path: build/app/outputs/flutter-apk/*.apk
```

---

**Last Updated:** October 21, 2025  
**Author:** Development Team

