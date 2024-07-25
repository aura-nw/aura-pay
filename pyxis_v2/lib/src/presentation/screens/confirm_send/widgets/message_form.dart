import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';

class ConfirmSendScreenMessageFormWidget extends StatelessWidget {
  final AppLocalizationManager localization;
  final AppTheme appTheme;

  const ConfirmSendScreenMessageFormWidget({
    required this.appTheme,
    required this.localization,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
