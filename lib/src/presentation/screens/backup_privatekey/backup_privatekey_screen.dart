import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/backup_privatekey/widgets/backup_private_key_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/backup_privatekey/widgets/backup_private_key_remind_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class BackupPrivateKeyScreen extends StatefulWidget {
  const BackupPrivateKeyScreen({super.key});

  @override
  State<BackupPrivateKeyScreen> createState() => _BackupPrivateKeyScreenState();
}

class _BackupPrivateKeyScreenState extends State<BackupPrivateKeyScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey: '',
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing05,
                vertical: Spacing.spacing07,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        BackupPrivateKeyRemindWidget(
                          appTheme: appTheme,
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize06,
                        ),
                        BackupPrivateKeyFormWidget(
                          appTheme: appTheme,
                        ),
                      ],
                    ),
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        text: localization.translate(''),
                        onPress: _onConfirm,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConfirm() {
    AppNavigator.pop();
  }
}
