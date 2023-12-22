import 'package:flutter/cupertino.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';

class SwitchWidget extends StatelessWidget {
  final bool isSelected;
  final void Function(bool) onChanged;

  const SwitchWidget({
    super.key,
    required this.onChanged,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return CupertinoSwitch(
          value: isSelected,
          onChanged: onChanged,
          activeColor: appTheme.surfaceColorBrand,
          trackColor: appTheme.surfaceColorGrayDefault,
          thumbColor: appTheme.surfaceColorWhite,
          offLabelColor: appTheme.surfaceColorGrayLight,
        );
      },
    );
  }
}
