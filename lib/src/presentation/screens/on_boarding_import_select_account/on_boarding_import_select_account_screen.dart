import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingImportSelectAccountScreen extends StatefulWidget {
  const OnBoardingImportSelectAccountScreen({super.key});

  @override
  State<OnBoardingImportSelectAccountScreen> createState() =>
      _OnBoardingImportSelectAccountScreenState();
}

class _OnBoardingImportSelectAccountScreenState
    extends State<OnBoardingImportSelectAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: AppBarStepWidget(
            appTheme: appTheme,
            onViewMoreInformationTap: () {},
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [

                      Expanded(
                        child: ListView(
                          children: [

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(text: 'text');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
