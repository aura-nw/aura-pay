import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/navigator.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';

class TransactionResultButtonFormWidget extends StatelessWidget {
  final AppTheme appTheme;
  final AppLocalizationManager localization;

  const TransactionResultButtonFormWidget({
    required this.appTheme,
    required this.localization,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextAppButton(
          text: localization.translate(
            LanguageKey.transactionResultScreenBackToHome,
          ),
          onPress: () => AppNavigator.popUntil(
            RoutePath.home,
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        PrimaryAppButton(
          text: localization.translate(
            LanguageKey.transactionResultScreenDone,
          ),
          onPress: () => AppNavigator.popUntil(
            RoutePath.send,
          ),
        ),
      ],
    );
  }
}
