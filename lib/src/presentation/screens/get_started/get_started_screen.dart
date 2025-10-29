import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aurapay/app_configs/di.dart';
import 'package:aurapay/app_configs/aura_pay_config.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/app_local_constant.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/error/error.dart';
import 'package:aurapay/src/core/helpers/app_launcher.dart';
import 'package:aurapay/src/core/utils/toast.dart';
import 'package:aurapay/src/navigator.dart';
import 'package:aurapay/src/presentation/widgets/base_screen.dart';

import 'get_started_cubit.dart';
import 'get_started_state.dart';
import 'widgets/button_form.dart';
import 'widgets/logo_form.dart';

/// Get Started screen - the onboarding entry point.
///
/// Allows users to:
/// - Create a new wallet
/// - Import an existing wallet
/// - Sign in with social providers (Google, Twitter, Apple)
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with StateFulBaseScreen, CustomFlutterToast {
  final AuraPayConfig _config = getIt.get<AuraPayConfig>();
  final GetStartedCubit _cubit = getIt.get<GetStartedCubit>();

  @override
  Widget child(
    BuildContext context,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return Column(
      children: [
        // Logo and app name section
        Expanded(
          child: GetStartedLogoFormWidget(
            walletName: _config.config.appName,
            appTheme: appTheme,
          ),
        ),
        const SizedBox(height: BoxSize.boxSize05),
        
        // Action buttons and social login section
        GetStartedButtonFormWidget(
          localization: localization,
          appTheme: appTheme,
          onCreateNewWallet: () => _onCheckHasPasscode(
            _onPushToCreateNew,
            _onReplacePasscodeToCreateNew,
          ),
          onImportExistingWallet: () => _onCheckHasPasscode(
            _onPushToAddExistingWallet,
            _onReplacePasscodeToAddExistingWallet,
          ),
          onTermClick: _onTermsOfServiceClick,
          onGoogleTap: () => _onSocialClick(Web3AuthLoginProvider.google),
          onTwitterTap: () => _onSocialClick(Web3AuthLoginProvider.twitter),
          onAppleTap: () => _onSocialClick(Web3AuthLoginProvider.apple),
        ),
      ],
    );
  }

  @override
  Widget wrapBuild(
    BuildContext context,
    Widget child,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<GetStartedCubit, GetStartedState>(
        listener: (context, state) {
          // Handle different states from social login flow
          switch (state.status) {
            case GetStartedStatus.none:
            case GetStartedStatus.onSocialLogin:
              // No action needed for initial and loading states
              break;
            case GetStartedStatus.loginSuccess:
              // Navigate to YetiBot introduction after successful login
              AppNavigator.push(RoutePath.socialLoginYetiBot, state.wallet);
              break;
            case GetStartedStatus.loginFailure:
              // Show error message if login failed
              showToast(state.error.toString());
              break;
          }
        },
        child: Scaffold(
          backgroundColor: appTheme.bgPrimary,
          body: child,
        ),
      ),
    );
  }

  /// Checks if user has set up a passcode before proceeding.
  ///
  /// If passcode exists, executes [hasPasscodeCallback].
  /// If not, navigates to passcode setup screen with [nonPasscodeCallback]
  /// to be executed after passcode is set.
  Future<void> _onCheckHasPasscode(
    VoidCallback hasPasscodeCallback,
    void Function(BuildContext) nonPasscodeCallback,
  ) async {
    final appSecureUseCase = getIt.get<AppSecureUseCase>();
    final hasPassCode = await appSecureUseCase.hasPasscode(
      key: AppLocalConstant.passCodeKey,
    );

    if (hasPassCode) {
      hasPasscodeCallback.call();
    } else {
      // Navigate to passcode setup with callback for post-setup action
      AppNavigator.push(
        RoutePath.setPasscode,
        {
          'callback': nonPasscodeCallback,
          'canBack': true,
        },
      );
    }
  }

  /// Navigates to create new wallet screen (when passcode already exists).
  void _onPushToCreateNew() {
    AppNavigator.push(RoutePath.createWallet);
  }

  /// Replaces passcode screen with create wallet screen (after passcode setup).
  void _onReplacePasscodeToCreateNew(BuildContext context) {
    AppNavigator.replaceWith(RoutePath.createWallet);
  }

  /// Replaces passcode screen with network selection (after passcode setup).
  void _onReplacePasscodeToAddExistingWallet(BuildContext context) {
    AppNavigator.replaceWith(RoutePath.selectNetwork);
  }

  /// Navigates to import wallet screen (when passcode already exists).
  void _onPushToAddExistingWallet() {
    AppNavigator.push(RoutePath.selectNetwork);
  }

  /// Initiates social login with the specified provider.
  void _onSocialClick(Web3AuthLoginProvider provider) {
    _cubit.onLogin(provider);
  }

  /// Opens the Terms of Service URL in external browser.
  Future<void> _onTermsOfServiceClick() async {
    try {
      await AppLauncher.launch(AppLocalConstant.termsOfServiceUrl);
      LogProvider.log('Opened Terms of Service');
    } catch (e, stackTrace) {
      AppErrorHandler.handle(
        e,
        stackTrace: stackTrace,
        customMessage: 'Failed to open Terms of Service',
      );
    }
  }
}

