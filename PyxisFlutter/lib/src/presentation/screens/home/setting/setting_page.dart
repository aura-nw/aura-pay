import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/setting/widgets/setting_option_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: AppBarWithOnlyTitle(
            appTheme: appTheme,
            titleKey: LanguageKey.settingPageAppBarTitle,
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(
                height: BoxSize.boxSize04,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                ),
                child: Column(
                  children: [
                    SettingOptionWidget(
                      iconPath: AssetIconPath.settingRecovery,
                      labelPath: LanguageKey.settingPageRecoveryMethods,
                      appTheme: appTheme,
                      onTap: () {
                        AppNavigator.push(
                          RoutePath.recoverMethod,
                        );
                      },
                    ),
                    SettingOptionWidget(
                      iconPath: AssetIconPath.settingPrivateKey,
                      labelPath: LanguageKey.settingPagePrivateKey,
                      appTheme: appTheme,
                      onTap: () {
                        AppNavigator.push(
                          RoutePath.controllerKeyManagement,
                        );
                      },
                    ),
                    SettingOptionWidget(
                      iconPath: AssetIconPath.settingDeviceManagement,
                      labelPath: LanguageKey.settingPageDeviceManagement,
                      appTheme: appTheme,
                      onTap: () {},
                    ),
                    SettingOptionWidget(
                      iconPath: AssetIconPath.settingAddressBook,
                      labelPath: LanguageKey.settingPageAddressBook,
                      appTheme: appTheme,
                      onTap: () {
                        AppNavigator.push(
                          RoutePath.addressBook,
                        );
                      },
                    ),
                    SettingOptionWidget(
                      iconPath: AssetIconPath.settingBiometric,
                      labelPath: LanguageKey.settingPagePasscode,
                      appTheme: appTheme,
                      onTap: () {
                        AppNavigator.push(
                          RoutePath.settingPassCodeAndBioMetric,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const HoLiZonTalDividerWidget(),
              const SizedBox(
                height: BoxSize.boxSize07,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                ),
                child: SettingOptionWidget(
                  iconPath: AssetIconPath.settingHelpCenter,
                  labelPath: LanguageKey.settingPageHelpCenter,
                  appTheme: appTheme,
                  onTap: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
