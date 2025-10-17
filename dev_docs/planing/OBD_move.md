# Plan Migration: OnBoarding (OBD) từ Pyxis_v2 sang AuraPay

## Mục tiêu
Di chuyển toàn bộ flow OnBoarding từ pyxis_v2 sang AuraPay một cách có hệ thống, đảm bảo app có thể build và run được sau mỗi bước migration.

## Tổng quan OnBoarding Flow

### Flow chính:
```
Splash Screen → GetStarted Screen → [Create/Import Wallet] → Create Passcode → Home Screen
```

### Các màn hình chính trong OBD:
1. **Splash Screen** - Kiểm tra trạng thái app
2. **GetStarted Screen** - Màn hình chính OBD với các options:
   - Create New Wallet
   - Import Existing Wallet
   - Social Login (Google, Twitter, Apple)
3. **Create Passcode Screen** - Tạo mã PIN bảo mật
4. **Generate Wallet Screen** - Tạo ví mới với Yeti Bot
5. **Select Network Screen** - Chọn network khi import
6. **Import Wallet Screen** - Import ví từ seed phrase
7. **Import Wallet Yeti Bot Screen** - Import với Yeti Bot assistant
8. **Social Login Yeti Bot Screen** - Login qua social với Yeti Bot
9. **Re-Login Screen** - Màn hình đăng nhập lại

---

## Phase 1: Setup Cơ bản và Dependencies

### Bước 1.1: Copy Cores Packages (Domain & Data Layer)
**Mục tiêu**: Setup layer data và domain - Clean Architecture foundation

**Files cần copy**:
```
pyxis_v2/cores/domain/ → aurapay/cores/domain/
pyxis_v2/cores/data/ → aurapay/cores/data/
```

**Nội dung**:
- Domain entities: Account, KeyStore, Balance, Token, etc.
- Domain repositories: Interfaces
- Domain use cases: Business logic
- Data repositories: Implementations
- Data DTOs: Data transfer objects
- Services interfaces

**Test**: 
- Chạy `flutter pub get` trong cores/domain và cores/data
- Đảm bảo không có error

---

### Bước 1.2: Copy Wallet Core Package
**Mục tiêu**: Cung cấp các utilities cho việc tạo/quản lý wallet

**Files cần copy**:
```
pyxis_v2/packages/wallet_core/ → aurapay/packages/wallet_core/
```

**Nội dung**:
- Chain management (EVM, Cosmos)
- Wallet utilities
- Address converter
- Message creator
- Stored key management

**Test**: 
- Chạy `flutter pub get` trong packages/wallet_core
- Build package thành công

---

### Bước 1.3: Update pubspec.yaml với Dependencies
**Mục tiêu**: Thêm tất cả dependencies cần thiết cho OBD

**Dependencies cần thêm vào `aurapay/pubspec.yaml`**:
```yaml
dependencies:
  # Local packages
  wallet_core:
    path: packages/wallet_core
  domain:
    path: cores/domain
  data:
    path: cores/data
  
  # State management
  flutter_bloc: ^9.1.1
  
  # DI
  get_it: ^8.2.0
  
  # Local storage
  shared_preferences: ^2.2.3
  flutter_secure_storage: ^9.2.2
  
  # Local database
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  
  # Web3 Auth
  web3auth_flutter: ^6.3.0
  
  # Serialization
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  
  # Helpers
  crypto: ^3.0.3
  path_provider: ^2.1.3
  intl: ^0.20.2
  url_launcher: ^6.3.0
  share_plus: ^12.0.0
  
  # UI
  flutter_svg: ^2.0.10+1
  fluttertoast: ^9.0.0
  shimmer: ^3.0.0
  qr_flutter: ^4.1.0
  
  # Network
  dio: ^5.5.0+1
  retrofit: ^4.1.0

dev_dependencies:
  freezed: ^2.5.2
  build_runner: ^2.4.11
  isar_generator: ^3.1.0+1
  retrofit_generator: ^8.2.1
  json_serializable: ^6.8.0
```

**Test**: 
- Chạy `flutter pub get` trong aurapay/
- Không có conflict dependencies

---

### Bước 1.4: Copy Assets
**Mục tiêu**: Copy tất cả assets cần thiết cho OBD

**Assets cần copy**:
```
pyxis_v2/assets/logo/ → aurapay/assets/logo/
pyxis_v2/assets/icon/ → aurapay/assets/icon/
pyxis_v2/assets/image/ → aurapay/assets/image/
pyxis_v2/assets/language/ → aurapay/assets/language/
pyxis_v2/assets/config/ → aurapay/assets/config/
pyxis_v2/assets/font/ → aurapay/assets/font/
```

**Update pubspec.yaml assets**:
```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/logo/
    - assets/icon/
    - assets/image/
    - assets/language/
    - assets/config/
  
  fonts:
    - family: Inter
      fonts:
        - asset: assets/font/Inter/Inter-VariableFont_slnt,wght.ttf
        - asset: assets/font/Inter/static/Inter-Regular.ttf
        - asset: assets/font/Inter/static/Inter-Bold.ttf
        - asset: assets/font/Inter/static/Inter-Medium.ttf
        - asset: assets/font/Inter/static/Inter-SemiBold.ttf
    - family: Mulish
      fonts:
        - asset: assets/font/Mulish/Mulish-VariableFont_wght.ttf
        - asset: assets/font/Mulish/static/Mulish-Regular.ttf
        - asset: assets/font/Mulish/static/Mulish-Bold.ttf
        - asset: assets/font/Mulish/static/Mulish-Medium.ttf
        - asset: assets/font/Mulish/static/Mulish-SemiBold.ttf
```

**Test**: 
- Chạy `flutter pub get`
- Assets được load thành công

---

## Phase 2: Core Infrastructure

### Bước 2.1: Setup Core Constants và Utilities
**Mục tiêu**: Tạo foundation constants và utilities cho app

**Files cần copy vào `aurapay/lib/src/core/`**:
```
constants/
├── app_color.dart          # Color definitions
├── app_local_constant.dart # Local storage keys, constants
├── asset_path.dart         # Asset paths constants
├── aura_ecosystem.dart     # Aura network configs
├── aura_scan.dart         # Explorer URLs
├── enum.dart              # App-wide enums
├── language_key.dart      # Translation keys
├── network.dart           # Network configurations
├── size_constant.dart     # UI spacing, sizes
└── typography.dart        # Text styles

utils/
├── app_date_format.dart   # Date formatting
├── app_util.dart          # General utilities
├── aura_util.dart         # Aura-specific utils
├── context_extension.dart # BuildContext extensions
├── copy.dart              # Copy to clipboard
├── dart_core_extension.dart # Dart extensions
├── debounce.dart          # Debounce functionality
├── json_formatter.dart    # JSON formatting
└── toast.dart             # Toast messages

helpers/
├── address_validator.dart # Address validation
├── app_launcher.dart      # URL launcher
├── crypto_helper.dart     # Cryptography helpers
└── share_network.dart     # Share functionality

observer/
├── observer_base.dart     # Observer pattern base
└── home_page_observer.dart # Home page specific observer
```

**Test**:
- Import các file constants trong main.dart
- Verify không có error
- Build app thành công

---

### Bước 2.2: Setup App Configs và DI
**Mục tiêu**: Setup Dependency Injection và App Configuration

**Files cần copy vào `aurapay/lib/app_configs/`**:
```
app_configs/
├── di.dart                    # Dependency injection setup
└── pyxis_mobile_config.dart   # App configuration model
```

**Nội dung di.dart bao gồm**:
- Register local services (Storage, Database)
- Register repositories
- Register use cases
- Register BLoCs/Cubits
- Initialize Isar database
- Initialize Web3Auth
- Setup network configurations

**Test**:
- Import di.dart và PyxisMobileConfig trong main.dart
- Verify GetIt dependencies registration
- No compilation errors

---

### Bước 2.3: Setup Application Global State
**Mục tiêu**: Setup global state management

**Files cần copy vào `aurapay/lib/src/application/global/`**:
```
app_global_state/
├── app_global_cubit.dart       # Global state cubit
├── app_global_state.dart       # State definition
└── app_global_state.freezed.dart

app_theme/
├── app_theme.dart              # Theme model
├── app_theme_builder.dart      # Theme builder widget
└── cubit/
    ├── app_theme_cubit.dart
    ├── app_theme_state.dart
    └── app_theme_state.freezed.dart

localization/
├── localization_manager.dart        # Localization manager
├── app_localization_provider.dart   # Localization provider
└── app_translations_delegate.dart   # Translation delegate
```

**AppGlobalState chính**:
```dart
enum AppGlobalStatus {
  authorized,    // User đã login
  unauthorized,  // User chưa login
}
```

**Test**:
- Wrap app với BlocProvider<AppGlobalCubit>
- Wrap app với theme builder
- Verify localization works

---

### Bước 2.4: Setup Local Storage Providers
**Mục tiêu**: Setup các provider cho local storage

**Files cần copy vào `aurapay/lib/src/application/provider/`**:
```
local/
├── account/
│   ├── account_db.dart                     # Isar schema
│   └── account_database_service_impl.dart  # Implementation
├── key_store/
│   ├── key_store_db.dart
│   └── key_store_database_service_impl.dart
├── balance/
│   ├── balance_db.dart
│   └── balance_database_service_impl.dart
├── token/
│   ├── token_db.dart
│   └── token_database_service_impl.dart
├── token_market/
│   ├── token_market_db.dart
│   └── token_market_database_service_impl.dart
├── localization_service_impl.dart
├── normal_storage_service_impl.dart
└── secure_storage_service_impl.dart

provider/
├── biometric_provider.dart
└── web3_auth_provider.dart

service/
├── api_service_path.dart
├── balance/
│   └── balance_service_impl.dart
├── nft/
│   └── nft_service_impl.dart
└── token_market/
    └── token_market_service_impl.dart
```

**Test**:
- Chạy `flutter pub run build_runner build` để generate Isar schemas
- Verify database schemas generated
- Test CRUD operations

---

## Phase 3: Navigation và Base Widgets

### Bước 3.1: Setup Navigation
**Mục tiêu**: Setup routing system

**Files cần copy vào `aurapay/lib/src/`**:
```
navigator.dart          # Navigation manager với routes
app_routes.dart         # Route transitions (Slide, Fade)
```

**Routes cần có cho OBD**:
```dart
RoutePath.splash
RoutePath.getStarted
RoutePath.setPasscode
RoutePath.createWallet
RoutePath.selectNetwork
RoutePath.importWallet
RoutePath.importWalletYetiBot
RoutePath.socialLoginYetiBot
RoutePath.reLogin
RoutePath.home
```

**Test**:
- Tạo dummy screens cho tất cả routes
- Test navigation giữa các screens
- Verify routes không bị crash

---

### Bước 3.2: Setup Base Widgets
**Mục tiêu**: Setup các widget tái sử dụng

**Files cần copy vào `aurapay/lib/src/presentation/widgets/`**:
```
base_screen.dart                    # Base screen với theme & localization
app_bar_widget.dart                 # Custom app bar
app_button.dart                     # Custom buttons
app_loading_widget.dart             # Loading indicators
dialog_provider.dart                # Dialog utilities
divider_widget.dart                 # Custom dividers
box_widget.dart                     # Container widgets
circle_avatar_widget.dart           # Avatar widget
icon_with_text_widget.dart          # Icon + Text combo
network_image_widget.dart           # Network image loader
yeti_bot_message_widget.dart        # Yeti bot messages
gradient_border_widget.dart         # Gradient borders

# Input widgets
text_input_base/
├── text_input_base_widget.dart
└── text_input_base_state.dart
text_input_search_widget.dart
input_password_widget.dart

# OnBoarding specific widgets
phrase_widget.dart                  # Seed phrase display
pass_phrase_form_widget.dart        # Seed phrase input
fill_words_widget.dart              # Word filling
key_board_number_widget.dart        # Number keyboard
switch_widget.dart                  # Custom switch
slider_base_widget.dart             # Custom slider

# Other widgets
scroll_bar_widget.dart
wallet_info_widget.dart
select_network_widget.dart
transaction_box_widget.dart

bottom_sheet_base/
├── bottom_sheet_base.dart
└── bottom_sheet_base_state.dart

combined_gridview.dart
combine_list_view.dart
```

**Test**:
- Tạo demo screen hiển thị các widgets
- Verify widgets render correctly
- Test các interactions (tap, input, etc.)

---

## Phase 4: OnBoarding Screens Implementation

### Bước 4.1: Splash Screen
**Mục tiêu**: Màn hình khởi động, kiểm tra authentication state

**Files cần copy vào `aurapay/lib/src/presentation/screens/splash/`**:
```
spash_screen.dart           # UI
splash_cubit.dart           # Business logic
splash_state.dart           # State definition
splash_state.freezed.dart   # Generated freezed file
```

**Logic flow**:
```
1. Hiển thị logo + app name (2s delay)
2. Kiểm tra hasPasscode
3. Kiểm tra hasAccount
4. Navigate dựa trên state:
   - notHasPassCodeOrError → GetStarted
   - hasPassCode → ReLogin
   - notHasPassCodeAndHasAccount → SetPasscode
   - hasAccountAndVerifyByBioSuccessful → Home
```

**Test**:
- Chạy app, verify splash hiển thị đúng
- Test navigation logic với các scenarios:
  - First time user (no account, no passcode)
  - Has account, no passcode
  - Has account, has passcode

---

### Bước 4.2: GetStarted Screen
**Mục tiêu**: Màn hình chính của OBD với các options

**Files cần copy vào `aurapay/lib/src/presentation/screens/get_started/`**:
```
get_started_screen.dart
get_started_cubit.dart
get_started_state.dart
get_started_state.freezed.dart
widgets/
├── logo_form.dart          # Logo + app name display
├── button_form.dart        # Action buttons
└── box_icon.dart          # Icon containers
```

**Features**:
- Create New Wallet button
- Import Existing Wallet button
- Social login buttons (Google, Twitter, Apple)
- Terms and conditions link

**Logic flow**:
```
1. Hiển thị logo + welcome message
2. Khi user chọn option:
   - Check hasPasscode
   - Nếu có passcode → Navigate trực tiếp
   - Nếu chưa có passcode → Navigate to SetPasscode với callback
3. Social login:
   - Call Web3Auth
   - On success → Navigate to SocialLoginYetiBot
   - On failure → Show toast error
```

**Test**:
- Test tất cả buttons
- Test social login flow
- Test passcode checking logic

---

### Bước 4.3: Create Passcode Screen
**Mục tiêu**: Tạo mã PIN bảo mật 6 số

**Files cần copy vào `aurapay/lib/src/presentation/screens/create_passcode/`**:
```
create_passcode_screen.dart
create_passcode_cubit.dart
create_passcode_state.dart
create_passcode_state.freezed.dart
widgets/
└── passcode_input_widget.dart
```

**Features**:
- Input 6-digit PIN
- Re-enter PIN confirmation
- Custom number keyboard
- Visual feedback (dots)
- Can back option (tuỳ context)

**Logic flow**:
```
1. Enter PIN (6 digits)
2. Re-enter PIN for confirmation
3. If match:
   - Save to secure storage
   - Call onCreatePasscodeDone callback
4. If not match:
   - Show error
   - Reset and try again
```

**Test**:
- Test input 6 digits
- Test confirmation logic
- Test mismatch scenario
- Test save to secure storage
- Test canBack flag

---

### Bước 4.4: Generate Wallet Screen
**Mục tiêu**: Tạo ví mới với Yeti Bot assistance

**Files cần copy vào `aurapay/lib/src/presentation/screens/generate_wallet/`**:
```
generate_wallet_creen.dart
generate_wallet_cubit.dart
generate_wallet_state.dart
generate_wallet_state.freezed.dart
generate_wallet_selector.dart
widgets/
└── app_bar_title.dart
```

**Features**:
- Generate wallet tự động
- Yeti Bot hiển thị step-by-step messages
- Hiển thị wallet address (Bech32 + EVM)
- Animation messages với delays
- "Get Started" button khi done

**Logic flow**:
```
1. Generate wallet ngay khi vào screen
2. Hiển thị Yeti Bot messages với animation:
   - "Creating wallet..."
   - "Generating keys..."
   - "Securing your wallet..."
   - "Here are your addresses:"
   - Show Bech32 address
   - Show EVM address
3. Enable "Get Started" button
4. On button press:
   - Store wallet to database
   - Store keys to secure storage
   - Update AppGlobalStatus → authorized
   - Navigate to Home
```

**Test**:
- Test wallet generation
- Test Yeti Bot messages animation
- Test addresses display (copy functionality)
- Test store wallet
- Test navigation to home

---

### Bước 4.5: Select Network Screen
**Mục tiêu**: Chọn network trước khi import wallet

**Files cần copy vào `aurapay/lib/src/presentation/screens/select_network/`**:
```
select_network_screen.dart
(Có thể không cần cubit, screen đơn giản)
```

**Features**:
- List các networks available
- Select network
- Navigate to ImportWallet với network đã chọn

**Test**:
- Test hiển thị danh sách networks
- Test select network
- Test navigation với params

---

### Bước 4.6: Import Wallet Screen
**Mục tiêu**: Import ví từ seed phrase

**Files cần copy vào `aurapay/lib/src/presentation/screens/import_wallet/`**:
```
import_wallet_screen.dart
import_wallet_bloc.dart
import_wallet_event.dart
import_wallet_event.freezed.dart
import_wallet_state.dart
import_wallet_state.freezed.dart
import_wallet_selector.dart
widgets/
├── import_wallet_input_widget.dart
├── import_wallet_suggestion_widget.dart
└── word_chip_widget.dart
```

**Features**:
- Input 12/24 words seed phrase
- Word suggestions
- Validate seed phrase
- Import và tạo wallet từ seed

**Logic flow**:
```
1. User nhập seed phrase (12 hoặc 24 từ)
2. Validate từng từ (phải có trong BIP39 wordlist)
3. Khi đủ số từ:
   - Validate seed phrase
   - Import wallet
   - Store to database
   - Navigate tiếp theo
```

**Test**:
- Test input seed phrase
- Test word validation
- Test import logic
- Test với seed phrase hợp lệ/không hợp lệ

---

### Bước 4.7: Import Wallet Yeti Bot Screen
**Mục tiêu**: Import với Yeti Bot assistant (for Web3Auth)

**Files cần copy vào `aurapay/lib/src/presentation/screens/import_wallet_yeti_bot/`**:
```
import_wallet_yeti_bot_screen.dart
import_wallet_yeti_bot_cubit.dart
import_wallet_yeti_bot_state.dart
import_wallet_yeti_bot_state.freezed.dart
import_wallet_yeti_bot_selector.dart
```

**Features**:
- Tương tự Generate Wallet nhưng cho import
- Hiển thị Yeti Bot messages
- Hiển thị wallet info sau khi import
- Button để hoàn tất

**Test**:
- Test import flow với wallet từ Web3Auth
- Test Yeti Bot messages
- Test store wallet

---

### Bước 4.8: Social Login Yeti Bot Screen
**Mục tiêu**: Complete social login flow

**Files cần copy vào `aurapay/lib/src/presentation/screens/social_login_yeti_bot/`**:
```
social_login_yeti_bot_screen.dart
social_login_yeti_bot_cubit.dart
social_login_yeti_bot_state.dart
social_login_yeti_bot_state.freezed.dart
social_login_yeti_bot_selector.dart
```

**Test**:
- Test social login completion
- Test wallet storage

---

### Bước 4.9: Re-Login Screen
**Mục tiêu**: Screen để user nhập lại PIN khi đã có tài khoản

**Files cần copy vào `aurapay/lib/src/presentation/screens/re_login/`**:
```
re_login_screen.dart
re_login_cubit.dart
re_login_state.dart
re_login_state.freezed.dart
```

**Features**:
- Input PIN (6 digits)
- Verify PIN với stored PIN
- Biometric authentication option
- Navigate to Home nếu success

**Test**:
- Test PIN verification
- Test biometric auth
- Test wrong PIN scenario
- Test navigation

---

## Phase 5: Main Application Setup

### Bước 5.1: Setup PyxisApplication Widget
**Mục tiêu**: Main app widget với tất cả providers và listeners

**Files cần tạo/update trong `aurapay/lib/src/`**:
```
pyxis_application.dart  (hoặc đổi tên thành aura_pay_application.dart)
```

**Nội dung**:
- MaterialApp setup
- Navigation configuration
- Theme configuration
- Localization delegates
- MultiBlocProvider với:
  - AppThemeCubit
  - AppGlobalCubit
- BlocListener for AppGlobalState changes:
  - authorized → navigate to Home
  - unauthorized → navigate to GetStarted

**Test**:
- Chạy app với PyxisApplication
- Verify app khởi động thành công
- Test navigation giữa authorized/unauthorized states

---

### Bước 5.2: Update main.dart
**Mục tiêu**: Setup entry point với full initialization

**Nội dung main.dart**:
```dart
void main() async {
  // 1. Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize LogProvider
  LogProvider.init(LogProviderImpl());
  
  // 3. Initialize AuraScan with environment
  AuraScan.init(environment);
  
  // 4. Load config from assets
  final config = await _loadConfig();
  
  // 5. Setup Isar database
  final path = (await getApplicationDocumentsDirectory()).path;
  final isar = await Isar.open([...schemas], directory: path);
  
  // 6. Initialize dependencies (DI)
  await di.initDependency(config, isar);
  
  // 7. Save default Aura token
  await _saveAuraToken();
  
  // 8. Load localization
  await AppLocalizationManager.instance.load();
  
  // 9. Initialize FlutterTrustWalletCore
  FlutterTrustWalletCore.init();
  
  // 10. Run app
  runApp(const PyxisApplication());
}
```

**Test**:
- Chạy `flutter run`
- App khởi động không crash
- Splash screen hiển thị
- Navigate đến GetStarted hoặc Home dựa vào state

---

## Phase 6: Testing và Polish

### Bước 6.1: Complete End-to-End Testing

**Test scenarios**:

1. **First time user - Create wallet**:
   ```
   Splash → GetStarted → SetPasscode → GenerateWallet → Home
   ```

2. **First time user - Import wallet**:
   ```
   Splash → GetStarted → SetPasscode → SelectNetwork → ImportWallet → Home
   ```

3. **First time user - Social login**:
   ```
   Splash → GetStarted → Social Auth → SetPasscode → SocialLoginYetiBot → Home
   ```

4. **Returning user with passcode**:
   ```
   Splash → ReLogin → Home
   ```

5. **User with account but no passcode**:
   ```
   Splash → SetPasscode → Home
   ```

**Test checklist**:
- [ ] All screens render correctly
- [ ] All navigations work
- [ ] Wallet generation works
- [ ] Wallet import works
- [ ] Social login works
- [ ] Passcode creation works
- [ ] Passcode verification works
- [ ] Biometric auth works (if available)
- [ ] Data persists after app restart
- [ ] Assets load correctly
- [ ] Translations work
- [ ] Themes work
- [ ] No memory leaks
- [ ] No crashes

---

### Bước 6.2: Create Dummy Home Screen
**Mục tiêu**: Tạo Home screen placeholder để test OBD flow hoàn chỉnh

**Files cần tạo**:
```
aurapay/lib/src/presentation/screens/home/
└── home_screen.dart  (dummy implementation)
```

**Nội dung**:
```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuraPay Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to AuraPay!'),
            Text('OnBoarding Completed Successfully'),
            ElevatedButton(
              onPressed: () {
                // Logout for testing
                context.read<AppGlobalCubit>().changeStatus(
                  AppGlobalStatus.unauthorized,
                );
              },
              child: Text('Logout (Test OBD again)'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Test**:
- Navigate đến Home sau complete OBD
- Test logout button → back to GetStarted

---

### Bước 6.3: Code Generation
**Mục tiêu**: Generate tất cả code cần thiết

**Commands cần chạy**:
```bash
# Generate freezed files
flutter pub run build_runner build --delete-conflicting-outputs

# Generate Isar database schemas
flutter pub run build_runner build --delete-conflicting-outputs

# Clean nếu cần
flutter clean
flutter pub get
```

**Test**:
- Tất cả .freezed.dart files generated
- Tất cả .g.dart files generated
- Không có build errors

---

### Bước 6.4: Clean up và Documentation
**Mục tiêu**: Dọn dẹp code và tạo documentation

**Tasks**:
1. Remove unused imports
2. Format code: `flutter format .`
3. Analyze code: `flutter analyze`
4. Fix all warnings
5. Add comments cho các functions phức tạp
6. Update README.md với:
   - Setup instructions
   - How to run
   - Architecture overview
   - OBD flow diagram
7. Tạo CHANGELOG.md

---

## Phase 7: Build Verification

### Bước 7.1: Build Android
```bash
cd aurapay
flutter build apk --debug
flutter build apk --release
```

**Verify**:
- APK builds successfully
- Install APK on device
- Test OBD flows on Android

---

### Bước 7.2: Build iOS
```bash
cd aurapay
flutter build ios --debug
flutter build ios --release
```

**Verify**:
- iOS build successfully
- Install on iOS device/simulator
- Test OBD flows on iOS

---

## Dependency Graph

```
┌─────────────────────────────────────────────┐
│           AuraPay Application               │
└─────────────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐       ┌────────▼────────┐
│  Presentation  │       │   Application   │
│   (Screens)    │◄──────┤  (BLoC/Cubit)   │
└────────────────┘       └─────────────────┘
                                 │
                         ┌───────┴────────┐
                         │                │
                  ┌──────▼─────┐   ┌──────▼──────┐
                  │   Domain   │   │    Data     │
                  │ (Use Cases)│◄──┤ (Repository)│
                  └────────────┘   └─────────────┘
                                          │
                         ┌────────────────┼────────────────┐
                         │                │                │
                  ┌──────▼─────┐   ┌──────▼──────┐  ┌─────▼────┐
                  │Wallet Core │   │    Isar     │  │ Dio/Web3 │
                  │  Package   │   │   Database  │  │   Auth   │
                  └────────────┘   └─────────────┘  └──────────┘
```

---

## File Count Summary

**Ước tính số lượng files cần move**:

```
Cores & Packages:
- cores/domain/: ~76 files
- cores/data/: ~54 files
- packages/wallet_core/: ~19 files
Total: ~149 files

Application Layer:
- global/: ~15 files
- provider/: ~20 files
Total: ~35 files

Core (Constants, Utils, Helpers):
- constants/: ~10 files
- utils/: ~10 files
- helpers/: ~4 files
- observers/: ~2 files
Total: ~26 files

Presentation:
- widgets/: ~40 files
- screens/splash/: 4 files
- screens/get_started/: 6 files
- screens/create_passcode/: 5 files
- screens/generate_wallet/: 6 files
- screens/select_network/: 2 files
- screens/import_wallet/: 10 files
- screens/import_wallet_yeti_bot/: 5 files
- screens/social_login_yeti_bot/: 5 files
- screens/re_login/: 4 files
- screens/home/: 1 file (dummy)
Total: ~88 files

Assets:
- logo/: 3 files
- icon/: 41 files
- image/: 4 files
- language/: 2 files
- config/: 3 files
- font/: 36 files
Total: ~89 files

Other:
- navigation: 2 files
- app_configs: 2 files
- main.dart: 1 file
Total: ~5 files

GRAND TOTAL: ~392 files
```

---

## Estimated Timeline

**Ước tính thời gian cho mỗi phase**:

- **Phase 1** (Setup Dependencies): 2-3 hours
- **Phase 2** (Core Infrastructure): 3-4 hours
- **Phase 3** (Navigation & Base Widgets): 2-3 hours
- **Phase 4** (OBD Screens): 5-7 hours
- **Phase 5** (Main App Setup): 1-2 hours
- **Phase 6** (Testing & Polish): 3-4 hours
- **Phase 7** (Build Verification): 1-2 hours

**Total estimated time**: 17-25 hours (2-3 working days)

---

## Risk Assessment

### High Risk Items:
1. **Database schema migration**: Isar schemas phải được generate đúng
2. **Web3Auth configuration**: Android/iOS configuration phức tạp
3. **Secure storage**: Passcode và private keys phải được bảo mật
4. **Dependencies conflicts**: Version conflicts giữa packages

### Mitigation:
1. Test database operations sau mỗi bước
2. Backup Web3Auth configs từ pyxis_v2
3. Test secure storage trên cả Android và iOS
4. Use exact versions từ pyxis_v2 pubspec.yaml

---

## Rollback Plan

Nếu có vấn đề nghiêm trọng:

1. **Git**: Commit sau mỗi phase để có thể rollback
2. **Backup**: Keep pyxis_v2 intact
3. **Branch strategy**: 
   ```
   main
   └── feature/obd-migration
       ├── phase-1-setup
       ├── phase-2-core
       ├── phase-3-navigation
       └── phase-4-screens
   ```

---

## Success Criteria

OBD migration được coi là thành công khi:

✅ All 5 OBD test scenarios work end-to-end  
✅ No crashes or errors during flows  
✅ Data persists correctly across app restarts  
✅ Both Android and iOS builds work  
✅ All assets load correctly  
✅ Translations work for both EN and VI  
✅ Passcode và wallet data được secure properly  
✅ Code quality: No critical analyzer warnings  
✅ Performance: Smooth animations, no lag  

---

## Next Steps After OBD

Sau khi OBD migration hoàn tất, các modules tiếp theo nên migrate theo thứ tự:

1. **Home Screen** - Wallet overview, balances
2. **Send/Receive** - Transaction flows
3. **Token Management** - Add/remove tokens
4. **Transaction History** - View past transactions
5. **Settings** - App settings, security
6. **Advanced features** - NFTs, Staking, etc.

---

## Notes

- Tất cả các bước phải được test kỹ trước khi chuyển sang bước tiếp theo
- Commit thường xuyên để có thể rollback nếu cần
- Document các issues gặp phải trong quá trình migration
- Maintain code quality standards (formatting, naming conventions)
- Keep pyxis_v2 as reference, không xoá cho đến khi hoàn toàn confirm migration thành công

---

**Document version**: 1.0  
**Created**: 2025-10-17  
**Last updated**: 2025-10-17  
**Author**: AI Assistant  
**Status**: Ready for implementation

