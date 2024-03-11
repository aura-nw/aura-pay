import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';

class BackupPrivateKeyFormWidget extends StatelessWidget {
  final AppTheme appTheme;

  const BackupPrivateKeyFormWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(
            Spacing.spacing04,
          ),
          height: BoxSize.boxSize14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadius04,
            ),
          ),
          child: SvgPicture.asset(
            '',
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconWithTextWidget(
              titlePath: '',
              svgIconPath: '',
              appTheme: appTheme,
              style: AppTypoGraPhy.bodyMedium02.copyWith(
                color: appTheme.contentColorBrand,
              ),
            ),
            TextWithIconWidget(
              titlePath: '',
              svgIconPath: '',
              appTheme: appTheme,
              style: AppTypoGraPhy.bodyMedium02.copyWith(
                color: appTheme.contentColorBrand,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
