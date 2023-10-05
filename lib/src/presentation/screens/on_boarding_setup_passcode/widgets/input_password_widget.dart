import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/border_constant.dart';
import 'package:pyxis_mobile/src/core/constants/spacing.dart';

class InputPasswordWidget extends StatelessWidget {
  final int length;
  final int fillIndex;
  final AppTheme appTheme;

  const InputPasswordWidget({
    required this.length,
    required this.appTheme,
    required this.fillIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          length,
          (index) {
            bool isFill = fillIndex >= 0 && index <= fillIndex;
            return Container(
              height: Spacing.spacingUnit12,
              width: Spacing.spacingUnit12,
              margin: const EdgeInsets.only(
                right: Spacing.spacingUnit14,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFill ? appTheme.primaryColor500 : null,
                border: isFill
                    ? null
                    : Border.all(
                        color: appTheme.borderColorGray,
                        width: BorderConstant.border01,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
