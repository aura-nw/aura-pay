import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'widgets/set_recovery_form_widget.dart';
import 'widgets/account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class SetRecoveryMethodScreen extends StatefulWidget {
  final AuraAccount account;

  const SetRecoveryMethodScreen({
    required this.account,
    super.key,
  });

  @override
  State<SetRecoveryMethodScreen> createState() =>
      _SetRecoveryMethodScreenState();
}

class _SetRecoveryMethodScreenState extends State<SetRecoveryMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey: LanguageKey.setRecoveryMethodScreenAppBarTitle,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing04,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      AccountWidget(
                        appTheme: appTheme,
                        address: widget.account.address,
                        accountName: widget.account.name,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize07,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey.setRecoveryMethodScreenContent,
                            ),
                            style: AppTypoGraPhy.body02.copyWith(
                              color: appTheme.contentColor700,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize06,
                      ),
                      SetRecoveryFormWidget(
                        appTheme: appTheme,
                        onChange: (p0) {

                        },
                      ),
                    ],
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey.setRecoveryMethodScreenSetButtonTitle,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize08,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
