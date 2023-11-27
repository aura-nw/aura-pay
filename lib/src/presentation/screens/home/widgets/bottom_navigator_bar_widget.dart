import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class BottomNavigatorBarWidget extends StatefulWidget {
  final AppTheme appTheme;

  const BottomNavigatorBarWidget({
    required this.appTheme,
    super.key,
  });

  @override
  State<BottomNavigatorBarWidget> createState() =>
      _BottomNavigatorBarWidgetState();
}

class _BottomNavigatorBarWidgetState extends State<BottomNavigatorBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.spacing06, vertical: Spacing.spacing04),
      decoration: BoxDecoration(
        color: widget.appTheme.surfaceColorWhite,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            BorderRadiusSize.borderRadius05,
          ),
          topRight: Radius.circular(
            BorderRadiusSize.borderRadius05,
          ),
        ),
        // border: Border(
        //   top: BorderSide(
        //     color: widget.appTheme.borderColorGrayLight,
        //     width: BorderSize.border01,
        //   ),
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarHome,
            AssetIconPath.homeBottomNavigatorBarHome,
            LanguageKey.homeScreenBottomNavigatorBarHome,
          ),
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarAccount,
            AssetIconPath.homeBottomNavigatorBarAccount,
            LanguageKey.homeScreenBottomNavigatorBarAccounts,
          ),
          SvgPicture.asset(
            AssetIconPath.homeBottomNavigatorBarScan,
          ),
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarHistory,
            AssetIconPath.homeBottomNavigatorBarHistory,
            LanguageKey.homeScreenBottomNavigatorBarHistory,
          ),
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarSetting,
            AssetIconPath.homeBottomNavigatorBarSetting,
            LanguageKey.homeScreenBottomNavigatorBarSetting,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    String iconPath,
    String activeIconPath,
    String labelPath,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          iconPath,
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                labelPath,
              ),
              style: AppTypoGraPhy.bodyMedium01.copyWith(
                color: widget.appTheme.contentColor500,
              ),
            );
          },
        ),
      ],
    );
  }
}
