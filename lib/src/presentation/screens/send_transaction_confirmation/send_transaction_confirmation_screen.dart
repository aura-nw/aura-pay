import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';

class SendTransactionConfirmationScreen extends StatefulWidget {
  const SendTransactionConfirmationScreen({super.key});

  @override
  State<SendTransactionConfirmationScreen> createState() =>
      _SendTransactionConfirmationScreenState();
}

class _SendTransactionConfirmationScreenState
    extends State<SendTransactionConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
        );
      },
    );
  }
}
