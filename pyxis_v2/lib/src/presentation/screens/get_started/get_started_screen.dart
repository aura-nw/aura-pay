import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/app_local_constant.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/utils/context_extension.dart';
import 'package:pyxis_v2/src/navigator.dart';
import 'package:pyxis_v2/src/presentation/screens/get_started/widgets/button_form.dart';
import 'package:pyxis_v2/src/presentation/screens/get_started/widgets/logo_form.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with StateFulBaseScreen {
  final PyxisMobileConfig _config = getIt.get<PyxisMobileConfig>();

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Column(
      children: [
        Expanded(
          child:  GetStartedLogoFormWidget(
            walletName: _config.appName,
            appTheme: appTheme,
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        GetStartedButtonFormWidget(
          localization: localization,
          appTheme: appTheme,
          onCreateNewWallet: () {
            _onCheckHasPasscode(_onPushToCreateNew,_onReplacePasscodeToCreateNew);
          },
          onImportExistingWallet: () {
            _onCheckHasPasscode(_onPushToAddExistingWallet,_onReplacePasscodeToAddExistingWallet);
          },
          onTermClick: () {},
        ),
      ],
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
      backgroundColor: appTheme.bgPrimary,
      body: child,
    );
  }

  void _onCheckHasPasscode(
    VoidCallback hasPasscodeCallBack,
    VoidCallback nonPasscodeCallBack,
  ) async {
    final appSecureUseCase = getIt.get<AppSecureUseCase>();

    final bool hasPassCode = await appSecureUseCase.hasPasscode(
      key: AppLocalConstant.passCodeKey,
    );

    if (hasPassCode) {
      hasPasscodeCallBack.call();
    } else {
      AppNavigator.push(
        RoutePath.setPasscode,
        nonPasscodeCallBack,
      );
    }
  }

  void _onPushToCreateNew(){
    AppNavigator.push(
      RoutePath.createWallet,
    );
  }

  void _onReplacePasscodeToCreateNew() {
    AppNavigator.replaceWith(
      RoutePath.createWallet,
    );
  }

  void _onReplacePasscodeToAddExistingWallet() {
    AppNavigator.replaceWith(
      RoutePath.importWallet,
    );
  }

  void _onPushToAddExistingWallet(){
    AppNavigator.push(
      RoutePath.importWallet,
    );
  }
}
