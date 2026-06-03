# AuraPay - Ví Aura Network

<div align="center">

**Ứng dụng ví tiền điện tử hiện đại, đa chuỗi được xây dựng bằng Flutter cho hệ sinh thái Aura Network**

[![Flutter](https://img.shields.io/badge/Flutter-3.35.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Private-red.svg)]()

[Tính năng](#-tính-năng) • [Kiến trúc](#-kiến-trúc) • [Bắt đầu](#-bắt-đầu) • [Tài liệu](#-tài-liệu)

</div>

---

## 📱 Tổng quan

**AuraPay** là một ứng dụng ví tiền điện tử đầy đủ tính năng, bảo mật cao, hỗ trợ cả hai chuỗi **EVM** và **Cosmos** trong hệ sinh thái Aura Network. Được xây dựng bằng Flutter để tương thích đa nền tảng (iOS & Android), ứng dụng cung cấp trải nghiệm mượt mà cho việc quản lý tài sản số, NFT và tương tác blockchain.

### Các mạng được hỗ trợ

- **Chuỗi Aura EVM** (Tương thích Ethereum)
  - Serenity Testnet (ChainID: 6322)
  - Euphoria Testnet
  - Mainnet (Xstaxy)

- **Chuỗi Aura Cosmos**
  - Serenity Testnet (auradev_1236-2)
  - Euphoria
  - Mainnet

---

## ✨ Tính năng

### 🔐 Xác thực & Bảo mật
- **Nhiều phương thức tạo ví**
  - Tạo ví mới với cụm từ ghi nhớ (12/24 từ)
  - Nhập từ seed phrase
  - Nhập từ private key
  - Đăng nhập xã hội qua Web3Auth (Google, Apple, Twitter, Facebook, v.v.)

- **Bảo mật nâng cao**
  - Bảo vệ bằng mã PIN 6 chữ số
  - Xác thực sinh trắc học (Vân tay/Face ID)
  - Lưu trữ khóa được mã hóa
  - Tích hợp secure enclave

### 💰 Quản lý tài sản
- **Hỗ trợ đa token**
  - Token AURA gốc
  - Token ERC20 (EVM)
  - Token CW20 (Cosmos)
  - Quản lý token tùy chỉnh

- **Tính năng token**
  - Theo dõi số dư thời gian thực
  - Chuyển đổi giá trị USD
  - Dữ liệu thị trường & PNL 24h
  - Bật/tắt token
  - Ẩn số dư nhỏ

### 🖼️ Hỗ trợ NFT
- Xem bộ sưu tập NFT
- Hiển thị metadata NFT (on-chain & off-chain)
- Hỗ trợ hợp đồng CW721
- Hiển thị hình ảnh và animation
- Ước tính giá trị NFT

### 📤 Giao dịch
- **Gửi**
  - Chọn đa token
  - Quản lý sổ địa chỉ
  - Hỗ trợ memo giao dịch
  - Điều chỉnh phí động (Chậm/Trung bình/Nhanh)
  - Xem trước & xác nhận giao dịch

- **Nhận**
  - Tạo mã QR
  - Hiển thị địa chỉ đa mạng
  - Sao chép địa chỉ một chạm
  - Lưu hình ảnh mã QR

### 🌐 Giao diện người dùng
- **Thiết kế hiện đại**
  - Hiệu ứng chuyển đổi mượt mà
  - Bố cục responsive
  - Font chữ tùy chỉnh (Inter, Mulish)
  - Nội dung quảng cáo dạng story

- **Hỗ trợ đa ngôn ngữ**
  - Tiếng Anh
  - Tiếng Việt
  - Tự động phát hiện ngôn ngữ hệ thống

- **Điều hướng**
  - Bảng điều khiển chính
  - Quản lý ví
  - Lịch sử giao dịch
  - Cài đặt & tùy chọn
  - Trình duyệt DApp (đang phát triển)

### 🚀 Tính năng dự kiến
- Hoán đổi token
- Chức năng staking
- Lịch sử giao dịch nâng cao
- Quản lý đa tài khoản

---

## 🏗️ Kiến trúc

### Clean Architecture

Dự án tuân theo các nguyên tắc **Clean Architecture** với sự phân tách rõ ràng:

```
┌─────────────────────────────────────────────┐
│         Tầng Presentation                    │
│  (UI, BLoC/Cubit, Screens, Widgets)         │
├─────────────────────────────────────────────┤
│           Tầng Domain                        │
│  (Entities, Use Cases, Repositories)        │
├─────────────────────────────────────────────┤
│            Tầng Data                         │
│  (DTOs, Repository Impl, Data Sources)      │
└─────────────────────────────────────────────┘
```

#### Chi tiết các tầng

**📦 Tầng Domain** (`cores/domain/`)
- Logic nghiệp vụ thuần Dart
- Entities độc lập platform
- Implementations của use case
- Interfaces của repository

**📦 Tầng Data** (`cores/data/`)
- Data transfer objects (DTOs)
- Implementations của repository
- Local data sources (Isar, Secure Storage)
- Remote data sources (API services)

**📦 Tầng Presentation** (`lib/src/`)
- Pattern BLoC để quản lý state
- Các thành phần UI và màn hình
- Navigation và routing
- Quản lý state toàn cục

### Quản lý State

- **Pattern**: BLoC (Business Logic Component)
- **Thư viện**: `flutter_bloc ^9.1.1`
- **Code Generation**: `freezed` cho immutable states
- **Dependency Injection**: Service locator `get_it`

### Cấu trúc dự án

```
aurapay/
├── android/                 # Code native Android
├── ios/                     # Code native iOS
├── assets/                  # Tài nguyên tĩnh
│   ├── config/             # Cấu hình môi trường
│   ├── font/               # Font tùy chỉnh
│   ├── icon/               # Icon SVG
│   ├── image/              # Hình ảnh
│   ├── language/           # File dịch
│   └── logo/               # Tài sản thương hiệu
├── cores/                   # Modules lõi
│   ├── domain/             # Tầng domain
│   └── data/               # Tầng data
├── packages/               # Packages local
│   ├── wallet_services/    # Blockchain core (EVM, Cosmos, TrustWalletCore)
│   ├── trust_wallet_core/  # TrustWallet native library
│   └── cache_network_image_extended/
├── lib/
│   ├── app_configs/        # DI & cấu hình
│   ├── src/
│   │   ├── application/    # Logic cấp ứng dụng
│   │   ├── core/           # Constants, utils, helpers
│   │   └── presentation/   # UI screens & widgets
│   └── main.dart           # Điểm vào ứng dụng
└── docs/                   # Tài liệu
```

---

## 🛠️ Công nghệ sử dụng

### Lõi
- **Flutter**: 3.35.0+
- **Dart**: 3.9.0+

### Quản lý State & Kiến trúc
- `flutter_bloc: ^9.1.1` - Quản lý state
- `freezed: ^2.5.2` - Code generation cho immutable classes
- `get_it: ^8.2.0` - Dependency injection

### Database & Storage
- `isar: ^3.1.0+1` - NoSQL database nhanh
- `flutter_secure_storage: ^9.2.2` - Lưu trữ mã hóa
- `shared_preferences: ^2.2.3` - Lưu trữ key-value

### Mạng
- `dio: ^5.5.0+1` - HTTP client
- `retrofit: ^4.1.0` - Type-safe REST client

### Blockchain & Crypto
- `wallet_services` (local) - Chức năng ví đa chuỗi (EVM + Cosmos)
- `web3auth_flutter: ^6.3.0` - Xác thực xã hội
- `trust_wallet_core` (local) - TrustWallet native library
- `crypto: ^3.0.3` - Hàm mã hóa

### Thành phần UI
- `flutter_svg: ^2.0.10+1` - Hiển thị SVG
- `qr_flutter: ^4.1.0` - Tạo mã QR
- `shimmer: ^3.0.0` - Hiệu ứng loading
- `fluttertoast: ^9.0.0` - Thông báo toast

### Tiện ích
- `intl: ^0.20.2` - Quốc tế hóa
- `url_launcher: ^6.3.0` - Mở URL
- `share_plus: ^12.0.0` - Chức năng chia sẻ
- `path_provider: ^2.1.3` - Đường dẫn file

---

## 🚀 Bắt đầu

### Yêu cầu

- **Flutter SDK**: 3.35.0 trở lên
- **Dart SDK**: 3.9.0 trở lên
- **iOS**: Xcode 14+ (cho phát triển iOS)
- **Android**: Android Studio với **SDK 26+ (Android 8.0+)** cho phát triển Android
  - ⚠️ **Lưu ý:** minSdkVersion là 26 (yêu cầu bởi Web3Auth và TrustWalletCore)

### Cài đặt

1. **Clone repository**
```bash
git clone <repository-url>
cd AuraPay
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Cài đặt dependencies cho local packages**
```bash
cd cores/domain && flutter pub get && cd ../..
cd cores/data && flutter pub get && cd ../..
cd packages/wallet_services && flutter pub get && cd ../..
cd packages/cache_network_image_extended && flutter pub get && cd ../..
```

4. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. **Cài đặt iOS Pods** (chỉ iOS)
```bash
cd ios
pod install
cd ..
```

### Chạy ứng dụng

#### Development (Serenity Testnet - Mặc định)
```bash
flutter run
# hoặc explicit set environment
flutter run --dart-define=ENV=development
```

#### Staging (Euphoria)
```bash
flutter run --dart-define=ENV=staging
```

#### Production
```bash
flutter run --dart-define=ENV=production
```

### Build

#### Android
```bash
flutter build apk --dart-define=ENV=production --release
# hoặc App Bundle cho Google Play
flutter build appbundle --dart-define=ENV=production --release
```

#### iOS
```bash
flutter build ios --dart-define=ENV=production --release
```

---

## 🔧 Cấu hình

### File môi trường

Ứng dụng sử dụng file cấu hình JSON cho các môi trường khác nhau:

- `assets/config/config.dev.json` - Development/Serenity
- `assets/config/config.staging.json` - Staging/Euphoria
- `assets/config/config.json` - Production

### Cấu trúc cấu hình

```json
{
  "APP_NAME": "AuraPay Wallet",
  "NATIVE_COIN": { "name": "...", "symbol": "AURA" },
  "COSMOS_INFO": { "chainId": "...", "rpc": "...", ... },
  "EVM_INFO": { "chainId": ..., "rpc": "...", ... },
  "API": { "v1": { "url": "..." }, "v2": { "url": "..." } },
  "WEB_3_AUTH": { "client_id": "...", ... }
}
```

---

## 🔑 Core Classes & Cấu hình

### Các lớp cấu hình chính

- **`AuraPayConfig`** - Lớp cấu hình chính của ứng dụng (trong `lib/app_configs/aura_pay_config.dart`)
  - Quản lý cấu hình môi trường
  - Cung cấp truy cập đến instance AppConfig
  
- **`AuraPayEnvironment`** - Enum môi trường (trong `cores/domain/`)
  - `AuraPayEnvironment.serenity` - Development/Testnet (default khi không set `--dart-define=ENV`)
  - `AuraPayEnvironment.staging` - Staging/Euphoria (`--dart-define=ENV=staging`)
  - `AuraPayEnvironment.production` - Production/Mainnet (`--dart-define=ENV=production`)

- **`AuraPayAccountConstant`** - Constants liên quan đến tài khoản (trong `lib/src/core/constants/aura_pay_account_constant.dart`)
  - Tên ví mặc định
  - Tiền tố tài khoản

### File cấu hình

```
lib/app_configs/
├── aura_pay_config.dart    # Các class config chính
└── di.dart                 # Thiết lập dependency injection
```

---

## 📚 Tài liệu

- [English Documentation](../README.md) - Tài liệu tiếng Anh
- [Chi tiết Kiến trúc](./ARCHITECTURE.md) - Sắp ra mắt
- [Tài liệu API](./API.md) - Sắp ra mắt
- [Hướng dẫn Đóng góp](./CONTRIBUTING.md) - Sắp ra mắt

---

## 🔒 Bảo mật

- **Quản lý Private Key**: Khóa không bao giờ rời khỏi thiết bị, được lưu dưới dạng mã hóa
- **Bảo vệ sinh trắc học**: Xác thực vân tay/Face ID tùy chọn
- **Khóa mã PIN**: Mã PIN 6 chữ số để truy cập ứng dụng
- **Giao tiếp bảo mật**: Tất cả các API call qua HTTPS
- **Tích hợp Web3Auth**: Đăng nhập xã hội bảo mật với key sharding

### Thực hành bảo mật tốt nhất

1. Không bao giờ chia sẻ seed phrase hoặc private key của bạn
2. Bật xác thực sinh trắc học
3. Đặt mã PIN mạnh
4. Xác minh chi tiết giao dịch trước khi xác nhận
5. Giữ ứng dụng được cập nhật

---

## 🧑‍💻 Cấu trúc mã nguồn

### Các màn hình chính

```
lib/src/presentation/screens/
├── splash/                  # Màn hình khởi động
├── get_started/            # Màn hình bắt đầu
├── create_passcode/        # Tạo mã PIN
├── generate_wallet/        # Tạo ví mới
├── import_wallet/          # Nhập ví
├── import_wallet_yeti_bot/ # Nhập ví với Yeti Bot
├── social_login_yeti_bot/  # Đăng nhập xã hội
├── select_network/         # Chọn mạng
├── re_login/               # Đăng nhập lại
├── home/                   # Trang chủ
│   ├── home/              # Tab Home
│   ├── wallet/            # Tab Wallet
│   ├── browser/           # Tab Browser
│   ├── history/           # Tab History
│   └── settings/          # Tab Settings
├── send/                   # Gửi token
├── confirm_send/          # Xác nhận gửi
├── transaction_result/    # Kết quả giao dịch
└── manage_token/          # Quản lý token
```

### Các BLoC/Cubit chính

```
├── SplashCubit            # Khởi tạo ứng dụng
├── GetStartedCubit        # Màn hình bắt đầu
├── CreatePasscodeCubit    # Tạo mã PIN
├── GenerateWalletCubit    # Tạo ví
├── ImportWalletBloc       # Nhập ví
├── ReLoginCubit           # Đăng nhập lại
├── HomeBloc               # Trang chủ chính
├── HomePageBloc           # Tab home
├── SendBloc               # Gửi token
├── ConfirmSendBloc        # Xác nhận giao dịch
├── ManageTokenBloc        # Quản lý token
└── AppGlobalCubit         # State toàn cục
```

### Use Cases

```
cores/domain/lib/src/use_case/
├── account_use_case.dart        # Quản lý tài khoản
├── key_store_use_case.dart      # Quản lý khóa
├── token_use_case.dart          # Quản lý token
├── balance_use_case.dart        # Quản lý số dư
├── nft_use_case.dart            # Quản lý NFT
├── token_market_use_case.dart   # Dữ liệu thị trường
├── web3_auth_use_case.dart      # Xác thực Web3
├── app_secure_use_case.dart     # Bảo mật ứng dụng
└── localization_use_case.dart   # Đa ngôn ngữ
```

### Entities chính

```
cores/domain/lib/src/entities/
├── account.dart           # Tài khoản người dùng
│   ├── Account           # Thông tin tài khoản
│   ├── AEvmInfo          # Thông tin EVM
│   └── ACosmosInfo       # Thông tin Cosmos
├── token.dart            # Token
├── balance.dart          # Số dư
├── nft.dart              # NFT & metadata
├── token_market.dart     # Dữ liệu thị trường
├── key_store.dart        # Lưu trữ khóa
├── network.dart          # Thông tin mạng
└── google_account.dart   # Tài khoản Google
```

---

## 🎨 Hướng dẫn phát triển

### Thêm màn hình mới

1. Tạo folder trong `lib/src/presentation/screens/`
2. Tạo BLoC/Cubit với state và event
3. Tạo UI screen
4. Đăng ký route trong `navigator.dart`
5. Đăng ký BLoC trong `di.dart`

### Thêm Use Case mới

1. Định nghĩa trong `cores/domain/lib/src/use_case/`
2. Tạo repository interface trong domain
3. Implement repository trong `cores/data/`
4. Đăng ký trong `di.dart`

### Thêm Entity mới

1. Tạo entity trong `cores/domain/lib/src/entities/`
2. Tạo DTO tương ứng trong `cores/data/lib/src/dto/`
3. Tạo database schema nếu cần (Isar)
4. Update service và repository

### Thêm dịch

1. Thêm key vào `assets/language/en.json`
2. Thêm bản dịch vào `assets/language/vi.json`
3. Sử dụng: `localization.translate('key')`

---

## 🧪 Testing

### Chạy tests
```bash
flutter test
```

### Chạy tests với coverage
```bash
flutter test --coverage
```

### Widget tests
```bash
flutter test test/widget_test.dart
```

---

## 🤝 Đóng góp

Đây là dự án nội bộ. Đối với những người đóng góp nội bộ, vui lòng tuân theo:

1. Tạo feature branch từ `develop`
2. Tuân theo cấu trúc code và quy ước đặt tên hiện có
3. Viết code sạch, có tài liệu
4. Test kỹ lưỡng trước khi submit PR
5. Cập nhật tài liệu khi cần

### Quy ước đặt tên

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private members**: `_leadingUnderscore`

### Git Workflow

```bash
# Tạo branch mới
git checkout -b feature/feature-name

# Commit changes
git add .
git commit -m "feat: description"

# Push và tạo PR
git push origin feature/feature-name
```

---

## 🐛 Xử lý sự cố

### Lỗi build

```bash
# Clean build
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Lỗi iOS Pods

```bash
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

### Lỗi Isar

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📊 Hiệu năng

- **App size**: ~50-70 MB (compressed)
- **Cold start**: < 3s trên thiết bị trung bình
- **Database**: Isar cung cấp truy vấn nhanh (<10ms)
- **State management**: BLoC đảm bảo hiệu năng tốt

---

## 🔄 CI/CD

### Build workflow
- Tự động build khi push lên `develop`/`main`
- Chạy tests và linting
- Generate APK/IPA artifacts

### Deployment
- **Internal Testing**: TestFlight (iOS), Firebase App Distribution (Android)
- **Production**: App Store, Google Play Store

---

## 📱 Phiên bản tối thiểu

- **iOS**: 12.0+
- **Android**: API 26 (Android 8.0)+

---

## 📄 License

Dự án này là nội bộ và độc quyền. Mọi quyền được bảo lưu.

---

## 👥 Nhóm phát triển

**Đội ngũ phát triển Aura Network**

---

## 📞 Hỗ trợ

Đối với các vấn đề và câu hỏi:
- Nhóm nội bộ: Sử dụng kênh giao tiếp của công ty
- Email: [email hỗ trợ nếu có]

---

## 🙏 Cảm ơn

- **Aura Network** - Hạ tầng blockchain
- **TrustWallet** - Thư viện wallet core
- **Web3Auth** - Xác thực xã hội
- **Flutter Community** - Các packages mã nguồn mở

---

## 📝 Changelog

### Version 1.0.0 (Current)
- ✅ Tạo và nhập ví
- ✅ Đăng nhập xã hội
- ✅ Quản lý token (Native, ERC20, CW20)
- ✅ NFT viewing
- ✅ Gửi/Nhận giao dịch
- ✅ Đa mạng (EVM + Cosmos)
- ✅ Đa ngôn ngữ (EN/VI)
- ✅ Bảo mật (Passcode, Biometric)

### Upcoming Features
- 🔜 Token swapping
- 🔜 Staking
- 🔜 DApp browser
- 🔜 Advanced transaction history
- 🔜 Multi-account management

---

## 🌟 Features Highlights

### Wallet Services Package
Package `wallet_services` cung cấp:
- Tạo HD wallet từ mnemonic
- Quản lý multiple chains (EVM + Cosmos)
- Signing transactions
- Address derivation
- Key management qua TrustWallet Core
- EVM integration (web3dart)

### Trust Wallet Core Package
Package `trust_wallet_core` cung cấp:
- Native TrustWallet Core binaries
- HDWallet creation và key derivation
- Mnemonic generation với entropy pool management

---

<div align="center">

**Được xây dựng với ❤️ sử dụng Flutter**

*Trao quyền cho tương lai của tài chính phi tập trung*

</div>

