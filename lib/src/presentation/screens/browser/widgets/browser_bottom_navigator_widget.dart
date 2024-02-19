import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class BrowserBottomNavigatorWidget extends StatelessWidget {
  final AppTheme appTheme;

  const BrowserBottomNavigatorWidget({
    required this.appTheme,
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
          SvgPicture.asset(
            AssetIconPath.commonArrowBack,
          ),
          SvgPicture.asset(
            AssetIconPath.commonArrowNext,
          ),
        ],
      ),
    );
  }
}
