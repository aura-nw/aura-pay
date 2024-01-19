import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_cubit.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

import 'application/global/app_global_state/app_global_cubit.dart';
import 'application/global/app_global_state/app_global_state.dart';
import 'application/global/app_theme/cubit/theme_cubit.dart';
import 'application/global/localization/app_translations_delegate.dart';
import 'application/global/localization/localization_manager.dart';

// Define the AuraWalletApplication widget
class AuraWalletApplication extends StatefulWidget {
  const AuraWalletApplication({Key? key}) : super(key: key);

  @override
  State<AuraWalletApplication> createState() => _AuraWalletApplicationState();
}

class _AuraWalletApplicationState extends State<AuraWalletApplication>
    with WidgetsBindingObserver {
  PyxisMobileConfig config = getIt.get<PyxisMobileConfig>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle different app lifecycle states
    switch (state) {
      case AppLifecycleState.inactive:
        // Handle inactive state
        break;
      case AppLifecycleState.resumed:
        // Handle resumed state
        break;
      case AppLifecycleState.detached:
        // Handle detached state
        break;
      case AppLifecycleState.paused:
        // Handle paused state
        break;
      case AppLifecycleState.hidden:
        // Handle hidden state
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (WidgetsBinding.instance.focusManager.primaryFocus?.hasFocus ??
            false) {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        navigatorKey: AppNavigator.navigatorKey,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: AppTypoGraPhy.interFontFamily,
        ),
        onGenerateRoute: AppNavigator.onGenerateRoute,
        initialRoute: RoutePath.splash,
        debugShowCheckedModeBanner: false,
        title: config.appName,
        locale: AppLocalizationManager.instance.getAppLocale(),
        localizationsDelegates: const [
          AppTranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizationManager.instance.supportedLang
            .map(
              (e) => Locale(e),
            )
            .toList(),
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (__) => AppThemeCubit(),
              ),
              BlocProvider(
                create: (_) => AppGlobalCubit(),
              ),
              BlocProvider(
                create: (_) => WalletConnectCubit(),
              ),
            ],
            child: Builder(builder: (builderContext) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<AppGlobalCubit, AppGlobalState>(
                    listenWhen: (previous, current) =>
                        current.status != previous.status,
                    listener: (context, state) {
                      // Listen to changes in AppGlobalState status
                      switch (state.status) {
                        case AppGlobalStatus.authorized:
                          // If the user is authorized, navigate to the home screen
                          AppNavigator.replaceAllWith(
                            RoutePath.home,
                          );
                          break;
                        case AppGlobalStatus.unauthorized:
                          // If the user is unauthorized, navigate to the get started screen
                          AppNavigator.replaceAllWith(RoutePath.getStarted);
                          break;
                      }
                    },
                  ),
                  BlocListener<WalletConnectCubit, WalletConnectState>(
                      listenWhen: (previous, current) =>
                          current.status != previous.status,
                      listener: (_, state) =>
                          walletConnectListener(builderContext, state))
                ],
                child: child ?? const SizedBox(),
              );
            }),
          );
        },
      ),
    );
  }

  // This function listens for changes in the WalletConnectState and performs actions based on the current status.
  Future walletConnectListener(
      BuildContext builderContext, WalletConnectState state) async {
    // Switch statement to handle different WalletConnectStatus
    switch (state.status) {
      // Case when the status is onConnect
      case WalletConnectStatus.onConnect:
        // If the user is authorized, navigate to the home screen
        // Check if the state data is of type ConnectingData
        if (state.data is ConnectingData) {
          // Cast the state data to ConnectingData
          ConnectingData connectingData = state.data as ConnectingData;
          // Show a dialog asking the user whether they want to connect to a certain account
          await showDialog<void>(
              context: AppNavigator.navigatorKey.currentContext!,
              builder: (BuildContext context) {
                // Return an AlertDialog
                return AlertDialog(
                  // Set the title of the dialog
                  title: Text('Connect to ${connectingData.account}'),
                  // Set the content of the dialog
                  content: Text(
                      'Do you want to connect to ${connectingData.account}?'),
                  // Set the actions of the dialog
                  actions: [
                    // Approve button
                    TextButton(
                        onPressed: () {
                          // Approve the connection
                          context
                              .read<WalletConnectCubit>()
                              .approveConnection(connectingData);
                          // Close the dialog
                          Navigator.pop(context);
                        },
                        child: const Text('Approve')),
                    // Reject button
                    TextButton(
                        onPressed: () {
                          // Reject the connection
                          context
                              .read<WalletConnectCubit>()
                              .rejectConnection(connectingData);
                          // Close the dialog
                          Navigator.pop(context);
                        },
                        child: const Text('Reject')),
                  ],
                );
              });
        }

        break;
      // Case when the status is none
      case WalletConnectStatus.none:
        // If the user is authorized, navigate to the home screen
        // Replace all routes with the reLogin route
        AppNavigator.replaceAllWith(
          RoutePath.reLogin,
        );
        break;
      // Case when the status is onRequest
      case WalletConnectStatus.onRequest:
        // If the user is unauthorized, navigate to the get started screen
        // Replace all routes with the scanQrFee route
        AppNavigator.replaceAllWith(RoutePath.scanQrFee);
        break;
    }
  }
}
