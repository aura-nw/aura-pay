import 'package:get_it/get_it.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
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

class AuraWalletApplication extends StatefulWidget {
  const AuraWalletApplication({Key? key}) : super(key: key);

  @override
  State<AuraWalletApplication> createState() => _AuraWalletApplicationState();
}

class _AuraWalletApplicationState extends State<AuraWalletApplication>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  PyxisMobileConfig config = getIt.get<PyxisMobileConfig>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.hidden:
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
            ],
            child: Builder(builder: (context) {
              return MultiBlocListener(
                listeners: [
                  BlocListener<AppGlobalCubit, AppGlobalState>(
                    listenWhen: (previous, current) =>
                        current.status != previous.status,
                    listener: (context, state) {
                      switch (state.status) {
                        case AppGlobalStatus.authorized:
                          // AppNavigator.replaceAllWith(RoutePath.home);
                          break;
                        case AppGlobalStatus.unauthorized:
                          AppNavigator.replaceAllWith(RoutePath.getStarted);
                          break;
                      }
                    },
                  ),
                ],
                child: child ?? const SizedBox(),
              );
            }),
          );
        },
      ),
    );
  }
}
