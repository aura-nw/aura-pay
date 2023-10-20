import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

class LabelInputWidget extends StatelessWidget {
  final bool isRequired;
  final String label;
  final String? value;
  final String? iconPath;
  final AppTheme theme;
  final VoidCallback? onIconTap;

  const LabelInputWidget({
    this.isRequired = false,
    required this.theme,
    required this.label,
    this.value,
    this.iconPath,
    this.onIconTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                value ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypoGraPhy.body03.copyWith(
                  color: theme.contentColor700,
                ),
              ),
            ),
            if (iconPath.isNotNullOrEmpty)
              ...[
                const SizedBox(
                  width: BoxSize.boxSize04,
                ),
                GestureDetector(
                  onTap: onIconTap,
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    iconPath!,
                  ),
                )
              ]
            else
              const SizedBox(),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel() {
    if (isRequired) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: AppTypoGraPhy.utilityLabelSm.copyWith(
                color: theme.contentColor700,
              ),
            ),
            TextSpan(
              text: ' *',
              style: AppTypoGraPhy.utilityLabelSm.copyWith(
                color: theme.contentColorDanger,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      label,
      style: AppTypoGraPhy.utilityLabelSm.copyWith(
        color: theme.contentColor700,
      ),
    );
  }
}
