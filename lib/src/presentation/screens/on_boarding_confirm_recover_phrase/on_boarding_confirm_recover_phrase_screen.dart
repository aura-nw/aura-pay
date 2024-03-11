import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'widgets/confirm_recover_phrase_content_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingConfirmRecoveryPhraseScreen extends StatefulWidget {
  const OnBoardingConfirmRecoveryPhraseScreen({super.key});

  @override
  State<OnBoardingConfirmRecoveryPhraseScreen> createState() =>
      _OnBoardingConfirmRecoveryPhraseScreenState();
}

class _OnBoardingConfirmRecoveryPhraseScreenState
    extends State<OnBoardingConfirmRecoveryPhraseScreen> {
  final TextEditingController _confirmRecoverPhraseController =
      TextEditingController();

  final TextEditingController _walletNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    _confirmRecoverPhraseController.dispose();
    super.dispose();
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
                    child: ConfirmRecoverPhraseContentWidget(
                      confirmPhraseController: _confirmRecoverPhraseController,
                      walletNameController: _walletNameController,
                      appTheme: appTheme,
                    ),
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return PrimaryAppButton(
                        text: localization.translate(
                          '',
                        ),
                        onPress: _onConfirm,
                        isDisable: true,
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

  void _onConfirm() {}
}
