import 'package:flutter/cupertino.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';

class SwitchWidget extends StatelessWidget {
  final bool isSelected;
  final void Function(bool) onChanged;
  final AppTheme appTheme;

  const SwitchWidget({
    super.key,
    required this.onChanged,
    required this.isSelected,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: isSelected,
      onChanged: onChanged,
      activeTrackColor: appTheme.bgBrandSolid,
      inactiveTrackColor: appTheme.bgQuaternary,
      thumbColor: appTheme.bgPrimary,
      offLabelColor: appTheme.bgQuaternary,
    );
  }
}
