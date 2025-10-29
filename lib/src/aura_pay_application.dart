import 'dart:ui' as ui;

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:aurapay/app_configs/di.dart';
import 'package:aurapay/app_configs/aura_pay_config.dart';
import 'package:aurapay/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:aurapay/src/application/global/app_global_state/app_global_state.dart';
import 'package:aurapay/src/application/global/app_theme/cubit/app_theme_cubit.dart';
import 'package:aurapay/src/application/global/localization/app_translations_delegate.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';
import 'package:aurapay/src/navigator.dart';

/// Root widget of the AuraPay application.
///
/// Sets up the MaterialApp with theming, localization, navigation,
/// and global state management using BLoC pattern.
final class AuraPayApplication extends StatefulWidget {
  const AuraPayApplication({super.key});

  @override
  State<AuraPayApplication> createState() => _AuraPayApplicationState();
}

class _AuraPayApplicationState extends State<AuraPayApplication>
    with WidgetsBindingObserver {
  final AuraPayConfig _config = getIt.get<AuraPayConfig>();

  @override
  void initState() {
    super.initState();
    // Observe app lifecycle changes (paused, resumed, etc.)
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Handle different app lifecycle states
    // Currently using switch for future extensibility
    switch (state) {
      case AppLifecycleState.resumed:
        // App is visible and responding to user input
        // TODO: Refresh data or resume operations if needed
        break;
      case AppLifecycleState.inactive:
        // App is inactive (e.g., phone call, system dialog)
        break;
      case AppLifecycleState.paused:
        // App is not visible to user (background)
        // TODO: Pause operations, save state if needed
        break;
      case AppLifecycleState.detached:
        // App is still in memory but not visible
        break;
      case AppLifecycleState.hidden:
        // App is hidden from user
        break;
    }
  }

  @override
  void dispose() {
    // Remove lifecycle observer to prevent memory leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get device's system locale and update localization manager
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    AppLocalizationManager.instance.updateDeviceLocale(systemLocale.languageCode);
    LogProvider.log('AuraPayApplication systemLocale: $systemLocale');
    
    return GestureDetector(
      // Dismiss keyboard when tapping outside of text fields
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final currentFocus = WidgetsBinding.instance.focusManager.primaryFocus;
        if (currentFocus?.hasFocus ?? false) {
          currentFocus?.unfocus();
        }
      },
      child: MaterialApp(
        navigatorKey: AppNavigator.navigatorKey,
        title: _config.config.appName,
        debugShowCheckedModeBanner: false,
        
        // Theme configuration
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: AppTypoGraPhy.mulish,
          tabBarTheme: const TabBarThemeData(
            labelPadding: EdgeInsets.only(right: Spacing.spacing05),
          ),
        ),
        
        // Navigation configuration
        onGenerateRoute: AppNavigator.onGenerateRoute,
        initialRoute: RoutePath.splash,
        
        // Localization configuration
        locale: AppLocalizationManager.instance.getAppLocale(),
        localizationsDelegates: const [
          AppTranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizationManager.instance.supportedLang
            .map((lang) => Locale(lang))
            .toList(),
        
        // App-wide state management and listeners
        builder: (_, child) {
          return MultiBlocProvider(
            // Provide global BLoCs
            providers: [
              BlocProvider(create: (_) => AppThemeCubit()),
              BlocProvider(create: (_) => AppGlobalCubit()),
            ],
            child: Builder(
              builder: (context) {
                return MultiBlocListener(
                  // Listen to global state changes
                  listeners: [
                    BlocListener<AppGlobalCubit, AppGlobalState>(
                      // Only listen when authentication status changes
                      listenWhen: (previous, current) =>
                          current.status != previous.status,
                      listener: (context, state) {
                        // Navigate based on authentication status
                        switch (state.status) {
                          case AppGlobalStatus.authorized:
                            // User is authenticated, go to home
                            AppNavigator.replaceAllWith(RoutePath.home);
                            break;
                          case AppGlobalStatus.unauthorized:
                            // User is not authenticated, go to onboarding
                            AppNavigator.replaceAllWith(RoutePath.getStarted);
                            break;
                        }
                      },
                    ),
                  ],
                  child: Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (context) => child ?? const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

