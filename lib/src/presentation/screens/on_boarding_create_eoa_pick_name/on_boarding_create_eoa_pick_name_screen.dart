import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class OnBoardingCreateEOAPickNameScreen extends StatefulWidget {
  const OnBoardingCreateEOAPickNameScreen({super.key});

  @override
  State<OnBoardingCreateEOAPickNameScreen> createState() =>
      _OnBoardingCreateEOAPickNameScreenState();
}

class _OnBoardingCreateEOAPickNameScreenState
    extends State<OnBoardingCreateEOAPickNameScreen> {
  final TextEditingController _walletNameController = TextEditingController();

  final int _maxWalletNameLength = 32;

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          appBar: AppBarWithOnlyTitle(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(''),
                                  style: AppTypoGraPhy.utilityLabelSm.copyWith(
                                    color: appTheme.contentColorBlack,
                                  ),
                                );
                              },
                            ),
                            Text(
                              '${_walletNameController.text.trim().length}/$_maxWalletNameLength',
                              style: AppTypoGraPhy.bodyMedium01.copyWith(
                                color: appTheme.contentColor300,
                              ),
                            ),
                          ],
                        ),
                        TextInputNormalWidget(
                          maxLength: _maxWalletNameLength,
                          controller: _walletNameController,
                        ),
                      ],
                    ),
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        text: localization.translate(
                          localization.translate(
                            '',
                          ),
                        ),
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
