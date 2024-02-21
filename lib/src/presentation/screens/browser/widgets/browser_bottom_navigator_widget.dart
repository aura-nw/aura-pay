import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class BrowserBottomNavigatorWidget extends StatelessWidget {
  final AppTheme appTheme;
  final bool bookMarkActive;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onBookmarkClick;

  const BrowserBottomNavigatorWidget({
    required this.appTheme,
    this.bookMarkActive = false,
    required this.onNext,
    required this.onBack,
    required this.onBookmarkClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTheme.bodyColorBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing05,
        vertical: Spacing.spacing04,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AssetIconPath.commonArrowBack,
            ),
          ),
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AssetIconPath.commonArrowNext,
            ),
          ),
          SvgPicture.asset(
            AssetLogoPath.logo,
          ),
          GestureDetector(
            onTap: onBookmarkClick,
            behavior: HitTestBehavior.opaque,
              child: bookMarkActive ?
              SvgPicture.asset(
                AssetIconPath.inAppBrowserBookMarkActive,
              )
                  :
              SvgPicture.asset(
                AssetIconPath.inAppBrowserBookMark,
              ),
          ),
        ],
      ),
    );
  }
}
