# AuraPay - Aura Network Wallet

<div align="center">

**A modern, multi-chain cryptocurrency wallet built with Flutter for the Aura Network ecosystem**

[![Flutter](https://img.shields.io/badge/Flutter-3.35.0+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Private-red.svg)]()

[Features](#-features) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Documentation](#-documentation)

</div>

---

## 📱 Overview

**AuraPay** is a feature-rich, secure cryptocurrency wallet application supporting both **EVM** and **Cosmos** chains within the Aura Network ecosystem. Built with Flutter for cross-platform compatibility (iOS & Android), it provides a seamless experience for managing digital assets, NFTs, and blockchain interactions.

> 📖 **Quick Links:**  
> - [Build Environments Guide](docs/BUILD_ENVIRONMENTS.md) - How to build for different environments
> - [Code Improvement Checklist](docs/CODE_IMPROVEMENT_CHECKLIST.md) - Development roadmap
> - [Vietnamese Documentation](docs/README_VI.md)

### Supported Networks

- **Aura EVM Chain** (Ethereum-compatible)
  - Serenity Testnet (ChainID: 6322)
  - Euphoria Testnet
  - Mainnet (Xstaxy)

- **Aura Cosmos Chain**
  - Serenity Testnet (auradev_1236-2)
  - Euphoria
  - Mainnet

---

## ✨ Features

### 🔐 Authentication & Security
- **Multiple Wallet Creation Methods**
  - Generate new wallet with mnemonic phrase (12/24 words)
  - Import from seed phrase
  - Import from private key
  - Social login via Web3Auth (Google, Apple, Twitter, Facebook, etc.)

- **Advanced Security**
  - 6-digit passcode protection
  - Biometric authentication (Fingerprint/Face ID)
  - Encrypted key storage
  - Secure enclave integration

### 💰 Asset Management
- **Multi-Token Support**
  - Native AURA token
  - ERC20 tokens (EVM)
  - CW20 tokens (Cosmos)
  - Custom token management

- **Token Features**
  - Real-time balance tracking
  - USD value conversion
  - Market data & 24h PNL
  - Enable/disable tokens
  - Hide small balances

### 🖼️ NFT Support
- View NFT collections
- Display NFT metadata (on-chain & off-chain)
- Support for CW721 contracts
- Image and animation rendering
- NFT value estimation

### 📤 Transactions
- **Send**
  - Multi-token selection
  - Address book management
  - Transaction memo support
  - Dynamic fee adjustment (Slow/Average/Fast)
  - Transaction preview & confirmation

- **Receive**
  - QR code generation
  - Multi-network address display
  - One-tap address copy
  - Save QR code image

### 🌐 User Interface
- **Modern Design**
  - Smooth animations & transitions
  - Responsive layouts
  - Custom fonts (Inter, Mulish)
  - Story-based promotional content

- **Multi-Language Support**
  - English
  - Vietnamese
  - Auto-detect system language

- **Navigation**
  - Home dashboard
  - Wallet management
  - Transaction history
  - Settings & preferences
  - DApp browser (planned)

### 🚀 Planned Features
- Token swapping
- Staking functionality
- DApp browser
- Advanced transaction history
- Multi-account management

---

## 🏗️ Architecture

### Clean Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────┐
│         Presentation Layer                   │
│  (UI, BLoC/Cubit, Screens, Widgets)         │
├─────────────────────────────────────────────┤
│           Domain Layer                       │
│  (Entities, Use Cases, Repositories)        │
├─────────────────────────────────────────────┤
│            Data Layer                        │
│  (DTOs, Repository Impl, Data Sources)      │
└─────────────────────────────────────────────┘
```

#### Layer Details

**📦 Domain Layer** (`cores/domain/`)
- Pure Dart business logic
- Platform-independent entities
- Use case implementations
- Repository interfaces

**📦 Data Layer** (`cores/data/`)
- Data transfer objects (DTOs)
- Repository implementations
- Local data sources (Isar, Secure Storage)
- Remote data sources (API services)

**📦 Presentation Layer** (`lib/src/`)
- BLoC pattern for state management
- UI components and screens
- Navigation and routing
- Global state management

### State Management

- **Pattern**: BLoC (Business Logic Component)
- **Library**: `flutter_bloc ^9.1.1`
- **Code Generation**: `freezed` for immutable states
- **Dependency Injection**: `get_it` service locator

### Project Structure

```
aurapay/
├── android/                 # Android native code
├── ios/                     # iOS native code
├── assets/                  # Static assets
│   ├── config/             # Environment configs
│   ├── font/               # Custom fonts
│   ├── icon/               # SVG icons
│   ├── image/              # Images
│   ├── language/           # Translations
│   └── logo/               # Brand assets
├── cores/                   # Core modules
│   ├── domain/             # Domain layer
│   └── data/               # Data layer
├── packages/               # Local packages
│   ├── wallet_core/        # Blockchain core
│   ├── aura_wallet_core/   # Aura-specific features
│   └── cache_network_image_extended/
├── lib/
│   ├── app_configs/        # DI & configuration
│   ├── src/
│   │   ├── application/    # App-level logic
│   │   ├── core/           # Constants, utils, helpers
│   │   └── presentation/   # UI screens & widgets
│   └── main.dart           # App entry point
└── docs/                   # Documentation
```

---

## 🛠️ Tech Stack

### Core
- **Flutter**: 3.35.0+
- **Dart**: 3.9.0+

### State Management & Architecture
- `flutter_bloc: ^9.1.1` - State management
- `freezed: ^2.5.2` - Code generation for immutable classes
- `get_it: ^8.2.0` - Dependency injection

### Database & Storage
- `isar: ^3.1.0+1` - Fast NoSQL database
- `flutter_secure_storage: ^9.2.2` - Encrypted storage
- `shared_preferences: ^2.2.3` - Key-value storage

### Networking
- `dio: ^5.5.0+1` - HTTP client
- `retrofit: ^4.1.0` - Type-safe REST client

### Blockchain & Crypto
- `wallet_core` (custom) - Multi-chain wallet functionality
- `web3auth_flutter: ^6.3.0` - Social authentication
- `web3dart: ^2.7.3` - Ethereum library
- `trust_wallet_core` - Wallet core library
- `crypto: ^3.0.3` - Cryptographic functions
- `bech32: ^0.2.2` - Bech32 encoding

### UI Components
- `flutter_svg: ^2.0.10+1` - SVG rendering
- `qr_flutter: ^4.1.0` - QR code generation
- `shimmer: ^3.0.0` - Loading effects
- `fluttertoast: ^9.0.0` - Toast notifications

### Utilities
- `intl: ^0.20.2` - Internationalization
- `url_launcher: ^6.3.0` - Open URLs
- `share_plus: ^12.0.0` - Share functionality
- `path_provider: ^2.1.3` - File paths

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.35.0 or higher
- **Dart SDK**: 3.9.0 or higher
- **iOS**: Xcode 14+ (for iOS development)
- **Android**: Android Studio with **SDK 26+ (Android 8.0+)** for Android development
  - ⚠️ **Note:** Minimum SDK updated from 24 to 26 to support Web3Auth and TrustWalletCore
  - See [TrustWallet Crash Fix](./docs/fixes/trustwallet-crash/) for details

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd AuraPay
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Install dependencies for local packages**
```bash
cd cores/domain && flutter pub get && cd ../..
cd cores/data && flutter pub get && cd ../..
cd packages/wallet_core && flutter pub get && cd ../..
cd packages/cache_network_image_extended && flutter pub get && cd ../..
```

4. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. **Install iOS Pods** (iOS only)
```bash
cd ios
pod install
cd ..
```

### Running the App

#### Development (Serenity Testnet - Default)
```bash
flutter run
# or explicitly
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

#### Using Scripts (Recommended)
```bash
# Run with specific environment
./scripts/run.sh development
./scripts/run.sh staging
./scripts/run.sh production
```

### Build

#### Android
```bash
# Development
flutter build apk --dart-define=ENV=development

# Staging
flutter build apk --dart-define=ENV=staging

# Production (Release)
flutter build apk --dart-define=ENV=production --release
# or App Bundle for Google Play
flutter build appbundle --dart-define=ENV=production --release
```

#### iOS
```bash
# Development
flutter build ios --dart-define=ENV=development

# Staging
flutter build ios --dart-define=ENV=staging

# Production (Release)
flutter build ios --dart-define=ENV=production --release
```

#### Using Build Scripts (Recommended)
```bash
# Build with script
./scripts/build.sh production android release
./scripts/build.sh staging ios debug
```

📖 **For detailed build instructions, see [Build Environments Guide](docs/BUILD_ENVIRONMENTS.md)**

---

## 🔧 Configuration

### Environment Files

The app uses JSON configuration files for different environments:

- `assets/config/config.dev.json` - Development/Serenity
- `assets/config/config.staging.json` - Staging/Euphoria
- `assets/config/config.json` - Production

### Configuration Structure

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

## 🔑 Core Classes & Configuration

### Main Configuration Classes

- **`AuraPayConfig`** - Main app configuration class (in `lib/app_configs/aura_pay_config.dart`)
  - Manages environment configs
  - Provides access to AppConfig instance
  
- **`AuraPayEnvironment`** - Environment enum
  - `AuraPayEnvironment.serenity` - Development/Testnet
  - `AuraPayEnvironment.staging` - Staging/Euphoria
  - `AuraPayEnvironment.production` - Production/Mainnet

- **`AuraPayAccountConstant`** - Account-related constants (in `lib/src/core/constants/aura_pay_account_constant.dart`)
  - Default wallet names
  - Account prefixes

### Configuration Files

```
lib/app_configs/
├── aura_pay_config.dart    # Main config classes
└── di.dart                 # Dependency injection setup
```

---

## 📚 Documentation

### General Documentation
- [Documentation Index](./docs/README.md) - Complete documentation index
- [Vietnamese Documentation](./docs/README_VI.md) - Tài liệu tiếng Việt
- [Build Environments Guide](./docs/BUILD_ENVIRONMENTS.md) - Multi-environment build guide
- [Code Improvement Checklist](./docs/CODE_IMPROVEMENT_CHECKLIST.md) - Development roadmap & improvements

### Troubleshooting & Fixes
- [Bug Fixes Documentation](./docs/fixes/README.md) - All bug fixes and troubleshooting guides
- [TrustWallet Crash Fix](./docs/fixes/trustwallet-crash/) - Fix for SIGSEGV crash on Android
  - [Technical Documentation](./docs/fixes/trustwallet-crash/TRUSTWALLETCORE_CRASH_FIX.md) (English)
  - [Quick Summary](./docs/fixes/trustwallet-crash/CRASH_FIX_SUMMARY_VI.md) (Vietnamese)
  - [Implementation Guide](./docs/fixes/trustwallet-crash/NEXT_STEPS.md) (Vietnamese)

### Coming Soon
- Architecture Details - Coming soon
- API Documentation - Coming soon
- Contributing Guide - Coming soon

---

## 🔒 Security

- **Private Key Management**: Keys never leave the device, stored in encrypted format
- **Biometric Protection**: Optional fingerprint/Face ID authentication
- **Passcode Lock**: 6-digit passcode for app access
- **Secure Communication**: All API calls over HTTPS
- **Web3Auth Integration**: Secure social login with key sharding

### Security Best Practices

1. Never share your seed phrase or private key
2. Enable biometric authentication
3. Set a strong passcode
4. Verify transaction details before confirming
5. Keep the app updated

---

## 🤝 Contributing

This is a private project. For internal contributors, please follow:

1. Create a feature branch from `develop`
2. Follow the existing code structure and naming conventions
3. Write clean, documented code
4. Test thoroughly before submitting PR
5. Update documentation as needed

---

## 📄 License

This project is private and proprietary. All rights reserved.

---

## 👥 Team

**Aura Network Development Team**

---

## 📞 Support

For issues and questions:
- Internal team: Use company communication channels
- Email: [support email if applicable]

---

## 🙏 Acknowledgments

- **Aura Network** - Blockchain infrastructure
- **TrustWallet** - Wallet core library
- **Web3Auth** - Social authentication
- **Flutter Community** - Open source packages

---

<div align="center">

**Built with ❤️ using Flutter**

*Empowering the future of decentralized finance*

</div>
