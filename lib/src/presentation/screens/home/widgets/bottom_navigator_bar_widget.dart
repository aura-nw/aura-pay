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
  final int currentIndex;
  final void Function(int) onTabSelect;
  final VoidCallback onScanTap;

  const BottomNavigatorBarWidget({
    required this.currentIndex,
    required this.appTheme,
    required this.onScanTap,
    required this.onTabSelect,
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
            AssetIconPath.homeBottomNavigatorBarHomeActive,
            LanguageKey.homeScreenBottomNavigatorBarHome,
            () {
              widget.onTabSelect(0);
            },
            widget.currentIndex == 0,
          ),
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarAccount,
            AssetIconPath.homeBottomNavigatorBarAccountActive,
            LanguageKey.homeScreenBottomNavigatorBarAccounts,
            () {
              widget.onTabSelect(1);
            },
            widget.currentIndex == 1,
          ),
          GestureDetector(
            onTap: widget.onScanTap,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AssetIconPath.homeBottomNavigatorBarScan,
            ),
          ),
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarHistory,
            AssetIconPath.homeBottomNavigatorBarHistoryActive,
            LanguageKey.homeScreenBottomNavigatorBarHistory,
            () {
              widget.onTabSelect(2);
            },
            widget.currentIndex == 2,
          ),
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarSetting,
            AssetIconPath.homeBottomNavigatorBarSettingActive,
            LanguageKey.homeScreenBottomNavigatorBarSetting,
            () {
              widget.onTabSelect(3);
            },
            widget.currentIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    String iconPath,
    String activeIconPath,
    String labelPath,
    VoidCallback onTap,
    bool isSelected,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isSelected ? activeIconPath : iconPath,
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
                  color: isSelected
                      ? widget.appTheme.contentColorBrandDark
                      : widget.appTheme.contentColor500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
