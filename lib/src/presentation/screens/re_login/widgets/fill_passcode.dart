import 'package:flutter/material.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/presentation/widgets/input_password_widget.dart';

class ReLoginFillPasscodeWidget extends StatelessWidget {
  final int fillIndex;
  final AppTheme appTheme;

  const ReLoginFillPasscodeWidget({
    required this.appTheme,
    required this.fillIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InputPasswordWidget(
        length: 6,
        appTheme: appTheme,
        fillIndex: fillIndex,
      ),
    );
  }
}
