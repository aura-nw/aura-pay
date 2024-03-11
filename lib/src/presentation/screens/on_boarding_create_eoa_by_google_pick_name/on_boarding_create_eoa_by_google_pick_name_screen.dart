import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class OnBoardingCreateEOAByGooglePickNameScreen extends StatefulWidget {
  const OnBoardingCreateEOAByGooglePickNameScreen({
    super.key,
  });

  @override
  State<OnBoardingCreateEOAByGooglePickNameScreen> createState() =>
      _OnBoardingCreateEOAByGooglePickNameScreenState();
}

class _OnBoardingCreateEOAByGooglePickNameScreenState
    extends State<OnBoardingCreateEOAByGooglePickNameScreen> {
  final TextEditingController _walletNameController = TextEditingController();

  final int _defaultWalletNameLength = 32;

  @override
  void initState() {
    _walletNameController.text = PyxisAccountConstant.defaultNormalWalletName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(
                                    '',
                                  ),
                                  style: AppTypoGraPhy.utilityLabelSm.copyWith(
                                    color: appTheme.contentColorBlack,
                                  ),
                                );
                              },
                            ),
                            Text(
                              '${_walletNameController.text.length}/$_defaultWalletNameLength',
                              style: AppTypoGraPhy.bodyMedium01.copyWith(
                                color: appTheme.contentColor500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize03,
                        ),
                        TextInputNormalWidget(
                          controller: _walletNameController,
                        ),
                      ],
                    ),
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        text: localization.translate(
                          '',
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
