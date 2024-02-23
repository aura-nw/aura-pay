import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class BrowserHeaderWidget extends StatelessWidget {
  final AppTheme appTheme;
  final int tabCount;
  final VoidCallback onViewTap;
  final VoidCallback onSearchTap;
  final String url;

  const BrowserHeaderWidget({
    required this.appTheme,
    this.tabCount = 0,
    required this.onViewTap,
    required this.onSearchTap,
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing05,
                vertical: Spacing.spacing03,
              ),
              decoration: BoxDecoration(
                color: appTheme.surfaceColorGrayDefault,
                borderRadius: BorderRadius.circular(
                  BorderRadiusSize.borderRadiusRound,
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AssetIconPath.inAppBrowserLock,
                  ),
                  const SizedBox(
                    width: BoxSize.boxSize03,
                  ),
                  Expanded(
                    child: Text(
                      url,
                      style: AppTypoGraPhy.body03.copyWith(
                        color: appTheme.contentColor300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        GestureDetector(
          onTap: onViewTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: appTheme.borderColorUnKnow,
                width: BoxSize.boxSize01,
              ),
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius02,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal :Spacing.spacing02,
            ),
            child: Text(
              tabCount.toString(),
              style: AppTypoGraPhy.heading01.copyWith(
                color: appTheme.contentColor700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
