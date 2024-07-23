import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_v2/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with StateFulBaseScreen {
  final AccountUseCase _accountUseCase = getIt.get<AccountUseCase>();
  final KeyStoreUseCase _keyStoreUseCase = getIt.get<KeyStoreUseCase>();

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return ListView(
      padding: const EdgeInsets.all(BoxSize.boxSize04),
      children: [
        _buildSectionHeader(
            localization.translate(LanguageKey.settingsPageProfileSection),
            appTheme),
        _buildListTile(
          context,
          localization.translate(LanguageKey.settingsPageEditProfile),
          Icons.person,
          appTheme,
        ),
        _buildListTile(
          context,
          localization.translate(LanguageKey.settingsPageChangePassword),
          Icons.lock,
          appTheme,
        ),
        _buildSectionHeader(
            localization.translate(LanguageKey.settingsPagePreferencesSection),
            appTheme),
        _buildListTile(
          context,
          localization.translate(LanguageKey.settingsPageLanguage),
          Icons.language,
          appTheme,
          onTap: () {
            // Handle language change
          },
        ),
        _buildListTile(
          context,
          localization.translate(LanguageKey.settingsPageNotifications),
          Icons.notifications,
          appTheme,
        ),
        _buildSectionHeader(
            localization.translate(LanguageKey.settingsPageSystemSection),
            appTheme),
        _buildListTile(
          context,
          localization.translate(LanguageKey.settingsPageResetOnboarding),
          Icons.refresh,
          appTheme,
        ),
        _buildListTile(
            context,
            localization.translate(LanguageKey.settingsPageLogout),
            Icons.exit_to_app,
            appTheme,
            onTap: () {}),
        ListTile(
            leading: Icon(Icons.exit_to_app, color: appTheme.utilityRed700),
            title: Text(
              'Restart flow OnBoarding ',
              style: AppTypoGraPhy.textMdMedium
                  .copyWith(color: appTheme.utilityRed700),
            ),
            subtitle: Text('( For testing only )',
                style: AppTypoGraPhy.textMdRegular
                    .copyWith(color: appTheme.utilityRed700, fontSize: 13)),
            onTap: () async {
              bool confirmLogout =
                  await _showLogoutConfirmationDialog(context, localization);
              if (confirmLogout) {
                // Handle logout
                await _accountUseCase.deleteAll();
                await _keyStoreUseCase.deleteAll();

                if (context.mounted) {
                  AppGlobalCubit.of(context).changeStatus(
                    AppGlobalStatus.unauthorized,
                  );
                }
              }
            }),
      ],
    );
  }

  Future<bool> _showLogoutConfirmationDialog(
      BuildContext context, AppLocalizationManager localization) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('This will remove all your stored wallet keys'),
          content: const Text(
              'This is just for testing the onboarding flow. It will be removed later. Are you sure you want to reset the OBD flow?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localization.translate('Cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localization.translate('Yes')),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
      backgroundColor: appTheme.bgPrimary,
      appBar: AppBarDefault(
        appTheme: appTheme,
        localization: localization,
        isLeftActionActive: false,
        title: Text(localization.translate(LanguageKey.settingsPageTitle)),
      ),
      body: child,
    );
  }

  Widget _buildSectionHeader(String title, AppTheme appTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.spacing02),
      child: Text(
        title,
        style: AppTypoGraPhy.textLgBold.copyWith(color: appTheme.textPrimary),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title,
    IconData icon,
    AppTheme appTheme, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: appTheme.fgPrimary),
      title: Text(
        title,
        style: AppTypoGraPhy.textMdMedium.copyWith(color: appTheme.textPrimary),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, color: appTheme.fgPrimary, size: 16),
      onTap: onTap,
    );
  }
}
