import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'widgets/pass_phrase_form_widget.dart';
import 'widgets/remind_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingRecoverPhraseScreen extends StatefulWidget {
  const OnBoardingRecoverPhraseScreen({super.key});

  @override
  State<OnBoardingRecoverPhraseScreen> createState() =>
      _OnBoardingRecoverPhraseScreenState();
}

class _OnBoardingRecoverPhraseScreenState
    extends State<OnBoardingRecoverPhraseScreen> {
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
                vertical: Spacing.spacing07,
                horizontal: Spacing.spacing05,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        RecoverPhraseRemindWidget(
                          appTheme: appTheme,
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize07,
                        ),
                        RecoveryPhraseWidget(
                          phrase: '',
                          appTheme: appTheme,
                        ),
                      ],
                    ),
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        text: localization.translate(''),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
