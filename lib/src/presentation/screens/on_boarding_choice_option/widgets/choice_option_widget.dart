import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class ChoiceOptionWidget extends StatelessWidget {
  final AppTheme theme;
  final bool isSelected;
  final String iconPath;
  final String title;
  final String content;
  final VoidCallback onPress;

  const ChoiceOptionWidget({
    required this.theme,
    required this.isSelected,
    required this.iconPath,
    required this.content,
    required this.title,
    required this.onPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.spacing04,
          vertical: Spacing.spacing05,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor50 : null,
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius02,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
            ),
            const SizedBox(
              width: Spacing.spacing03,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypoGraPhy.heading01.copyWith(
                      color: isSelected
                          ? theme.contentColorBrand
                          : theme.contentColorBlack,
                    ),
                  ),
                  const SizedBox(
                    height: Spacing.spacing02,
                  ),
                  Text(
                    content,
                    style: AppTypoGraPhy.body02.copyWith(
                      color: theme.contentColor700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
