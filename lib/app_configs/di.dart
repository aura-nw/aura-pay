import 'dart:io';
import 'dart:typed_data';

import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:aura_wallet_core/aura_wallet_core.dart';
import 'package:aura_wallet_core/config_options/environment_options.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar/isar.dart';
import 'package:pyxis_mobile/src/application/provider/local_database/account_database_service_impl.dart';
import 'package:pyxis_mobile/src/application/provider/secure_storage/secure_storage_service_impl.dart';
import 'package:pyxis_mobile/src/application/provider/smart_account/smart_account_provider_impl.dart';
import 'package:pyxis_mobile/src/application/provider/wallet/wallet_provider.dart';
import 'package:pyxis_mobile/src/application/provider/web3_auth/web3_auth_provider_impl.dart';
import 'package:pyxis_mobile/src/application/service/transaction/transaction_api_service_impl.dart';
import 'package:pyxis_mobile/src/core/constants/app_local_constant.dart';
import 'package:pyxis_mobile/src/core/observers/recovery_observer.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/history_page_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_import_key/on_boarding_import_key_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_pick_account/on_boarding_pick_account_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_re_login/on_boarding_re_login_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_choice/on_boarding_recover_choice_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_select_account/on_boarding_recover_select_account_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_sign/on_boarding_recover_sign_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_scan_fee/on_boarding_scan_fee_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_setup_passcode/on_boarding_setup_passcode_cubit.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method/recovery_method_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method_confirmation/recovery_method_confirmation_screen.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method_confirmation/recovery_method_confirmation_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction/send_transaction_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction_confirmation/send_transaction_confirmation_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/set_recovery_method/set_recovery_method_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_new_sm_account_pick_account/signed_in_create_new_sm_account_pick_account_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_create_new_sm_account_scan_fee/signed_in_create_new_sm_account_scan_fee_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_import_key/signed_in_import_key_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_recover_choice/signed_in_recover_choice_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_recover_select_account/signed_in_recover_select_account_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/signed_in_recover_sign/signed_in_recover_sign_bloc.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

import 'pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/presentation/screens/splash/splash_screen_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> initDependency(
  PyxisMobileConfig config,
  Isar isar,
) async {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: config.lcdUrl,
      connectTimeout: const Duration(
        milliseconds: 60000,
      ),
      receiveTimeout: const Duration(
        milliseconds: 60000,
      ),
      contentType: 'application/json; charset=utf-8',
    ),
  );

  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: AppLocalConstant.keyDbName,
    ),
    iOptions: IOSOptions(),
  );

  // Set web3 auth redirect uri
  // Must replace late
  Uri redirectUrl;
  if (Platform.isAndroid) {
    redirectUrl = Uri.parse('app://com.aura.network.pyxis_mobile/auth');
  } else {
    redirectUrl = Uri.parse('com.example.w3aflutter://openlogin');
  }

  await Web3AuthFlutter.init(
    Web3AuthOptions(
      clientId: config.web3AuthClientId,
      network: Network.sapphire_devnet,
      redirectUrl: redirectUrl,
    ),
  );

  final AuraWalletCore coreWallet = AuraWalletCore.create(
    environment: AuraEnvironment.dev,
  );

  final AuraSmartAccount auraSmartAccount = AuraSmartAccount.create(
    AuraSmartAccountEnvironment.test,
  );

  getIt.registerFactory<Dio>(
    () => dio,
  );

  getIt.registerLazySingleton<PyxisMobileConfig>(
    () => config,
  );

  getIt.registerLazySingleton<RecoveryObserver>(
    () => RecoveryObserver(),
  );

  ///Api service

  getIt.registerLazySingleton<TransactionApiServiceGenerate>(
    () => TransactionApiServiceGenerate(
      getIt.get<Dio>(),
    ),
  );

  getIt.registerLazySingleton<TransactionApiService>(
    () => TransactionApiServiceImpl(
      getIt.get<TransactionApiServiceGenerate>(),
    ),
  );

  ///Provider

  getIt.registerLazySingleton<WalletProvider>(
    () => WalletProviderImpl(coreWallet),
  );

  getIt.registerLazySingleton<SmartAccountProvider>(
    () => SmartAccountProviderImpl(
      auraSmartAccount,
    ),
  );

  getIt.registerLazySingleton<Web3AuthProvider>(
    () => const Web3AuthProviderImpl(),
  );

  /// Local

  getIt.registerLazySingleton<AccountDatabaseService>(
    () => AccountDatabaseServiceImpl(
      isar,
    ),
  );

  getIt.registerLazySingleton<SecureStorageService>(
    () => const SecureStorageServiceImpl(
      secureStorage,
    ),
  );

  ///Repository

  getIt.registerLazySingleton<AppSecureRepository>(
    () => AppSecureRepositoryImpl(
      getIt.get<SecureStorageService>(),
    ),
  );

  getIt.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(),
  );

  getIt.registerLazySingleton<Web3AuthRepository>(
    () => Web3AuthRepositoryImpl(
      getIt.get<Web3AuthProvider>(),
    ),
  );

  getIt.registerLazySingleton<SmartAccountRepository>(
    () => SmartAccountRepositoryImpl(
      getIt.get<SmartAccountProvider>(),
    ),
  );

  getIt.registerLazySingleton<ControllerKeyRepository>(
    () => ControllerKeyRepositoryImpl(
      getIt.get<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<AuraAccountRepository>(
    () => AuraAccountRepositoryImpl(
      getIt.get<AccountDatabaseService>(),
    ),
  );

  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      getIt.get<WalletProvider>(),
    ),
  );

  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      getIt.get<TransactionApiService>(),
    ),
  );

  ///Use case
  getIt.registerLazySingleton<AppSecureUseCase>(
    () => AppSecureUseCase(
      getIt.get<AppSecureRepository>(),
    ),
  );

  getIt.registerLazySingleton<LocalizationUseCase>(
    () => LocalizationUseCase(
      getIt.get<LocalizationRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => WalletUseCase(
      getIt.get<WalletRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => Web3AuthUseCase(
      getIt.get<Web3AuthRepository>(),
    ),
  );

  getIt.registerLazySingleton<SmartAccountUseCase>(
    () => SmartAccountUseCase(
      getIt.get<SmartAccountRepository>(),
    ),
  );

  getIt.registerLazySingleton<AuraAccountUseCase>(
    () => AuraAccountUseCase(
      getIt.get<AuraAccountRepository>(),
    ),
  );
  getIt.registerLazySingleton<ControllerKeyUseCase>(
    () => ControllerKeyUseCase(
      getIt.get<ControllerKeyRepository>(),
    ),
  );

  getIt.registerLazySingleton<TransactionUseCase>(
    () => TransactionUseCase(
      getIt.get<TransactionRepository>(),
    ),
  );

  ///Bloc
  getIt.registerFactory<SplashScreenCubit>(
    () => SplashScreenCubit(
      getIt.get<AppSecureUseCase>(),
    ),
  );

  getIt.registerFactory<OnBoardingPickAccountBloc>(
    () => OnBoardingPickAccountBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
    ),
  );

  getIt.registerFactory<OnBoardingImportKeyBloc>(
    () => OnBoardingImportKeyBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      getIt.get<AuraAccountUseCase>(),
    ),
  );

  getIt.registerFactoryParam<OnBoardingScanFeeBloc, Map<String, String>,
      Map<String, Uint8List>>(
    (smartAccount, accountRaw) => OnBoardingScanFeeBloc(
      getIt.get<SmartAccountUseCase>(),
      getIt.get<AuraAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      smartAccountAddress: smartAccount['smartAccountAddress']!,
      accountName: smartAccount['accountName']!,
      privateKey: accountRaw['privateKey']!,
      salt: accountRaw['salt']!,
    ),
  );

  getIt.registerFactory<OnBoardingRecoverChoiceBloc>(
    () => OnBoardingRecoverChoiceBloc(
      getIt.get<Web3AuthUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => HomeScreenBloc(
      getIt.get<AuraAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => SignedInCreateNewSmAccountPickAccountBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
    ),
  );

  getIt.registerFactoryParam<SignedInCreateNewSmAccountScanFeeBloc,
      Map<String, String>, Map<String, Uint8List>>(
    (smartAccount, accountRaw) => SignedInCreateNewSmAccountScanFeeBloc(
      getIt.get<SmartAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      getIt.get<AuraAccountUseCase>(),
      smartAccountAddress: smartAccount['smartAccountAddress']!,
      accountName: smartAccount['accountName']!,
      privateKey: accountRaw['privateKey']!,
      salt: accountRaw['salt']!,
    ),
  );

  getIt.registerFactory(
    () => SignedInImportKeyBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
      getIt.get<AuraAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
    ),
  );

  getIt.registerFactory<OnBoardingSetupPasscodeBloc>(
    () => OnBoardingSetupPasscodeBloc(
      getIt.get<AppSecureUseCase>(),
    ),
  );
  getIt.registerFactory<OnBoardingReLoginBloc>(
    () => OnBoardingReLoginBloc(
      getIt.get<AppSecureUseCase>(),
      getIt.get<AuraAccountUseCase>(),
    ),
  );

  getIt.registerFactory<SendTransactionBloc>(
    () => SendTransactionBloc(
      getIt.get<AuraAccountUseCase>(),
      getIt.get<SmartAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
    ),
  );

  getIt.registerFactoryParam<SendTransactionConfirmationBloc, AuraAccount,
      Map<String, dynamic>>(
    (account, transactionI) => SendTransactionConfirmationBloc(
      getIt.get<SmartAccountUseCase>(),
      getIt.get<WalletUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      sender: account,
      recipient: transactionI['recipient'],
      amount: transactionI['amount'],
      transactionFee: transactionI['fee'],
      estimationGas: transactionI['gas'],
    ),
  );

  getIt.registerFactory<HistoryPageBloc>(
    () => HistoryPageBloc(
      getIt.get<TransactionUseCase>(),
      getIt.get<AuraAccountUseCase>(),
    ),
  );

  getIt.registerFactory<RecoveryMethodScreenBloc>(
    () => RecoveryMethodScreenBloc(
      getIt.get<AuraAccountUseCase>(),
    ),
  );

  getIt.registerFactory<SignedInRecoverChoiceBloc>(
    () => SignedInRecoverChoiceBloc(
      getIt.get<Web3AuthUseCase>(),
    ),
  );

  getIt.registerFactory(
    () => SetRecoveryMethodScreenBloc(
      getIt.get<Web3AuthUseCase>(),
    ),
  );

  getIt.registerFactoryParam<RecoveryMethodConfirmationBloc,
      RecoveryMethodConfirmationArgument, dynamic>(
    (argument, _) => RecoveryMethodConfirmationBloc(
      getIt.get<SmartAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      getIt.get<WalletUseCase>(),
      getIt.get<Web3AuthUseCase>(),
      getIt.get<AuraAccountUseCase>(),
      argument: argument,
    ),
  );

  getIt.registerFactoryParam<OnBoardingRecoverSelectAccountBloc, GoogleAccount,
      dynamic>(
    (googleAccount, _) => OnBoardingRecoverSelectAccountBloc(
      getIt.get<AuraAccountUseCase>(),
      googleAccount: googleAccount,
    ),
  );

  getIt.registerFactoryParam<OnBoardingRecoverSignBloc, AuraAccount,
      GoogleAccount>(
    (account, googleAccount) => OnBoardingRecoverSignBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      getIt.get<Web3AuthUseCase>(),
      account: account,
      googleAccount: googleAccount,
    ),
  );

  getIt.registerFactoryParam<SingedInRecoverSelectAccountBloc, GoogleAccount,
      dynamic>(
    (googleAccount, _) => SingedInRecoverSelectAccountBloc(
      getIt.get<AuraAccountUseCase>(),
      googleAccount: googleAccount,
    ),
  );

  getIt.registerFactoryParam<SignedInRecoverSignBloc, AuraAccount,
      GoogleAccount>(
        (account, googleAccount) => SignedInRecoverSignBloc(
      getIt.get<WalletUseCase>(),
      getIt.get<SmartAccountUseCase>(),
      getIt.get<ControllerKeyUseCase>(),
      getIt.get<Web3AuthUseCase>(),
      getIt.get<AuraAccountUseCase>(),
      account: account,
      googleAccount: googleAccount,
    ),
  );
}
