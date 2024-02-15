import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class BottomNavigatorBarWidget extends StatefulWidget {
  final AppTheme appTheme; // The app theme
  final int currentIndex; // The current selected index
  final void Function(int)
      onTabSelect; // Callback function when a tab is selected
  final VoidCallback
      onScanTap; // Callback function when the scan button is tapped

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
          horizontal: Spacing.spacing06,
          vertical: Spacing.spacing04), // Padding for the container
      decoration: BoxDecoration(
        color: widget.appTheme.surfaceColorWhite, // Background color
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            color: Colors.black.withOpacity(0.1), // Shadow color
            blurRadius: 16, // Shadow blur radius
            spreadRadius: 0,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(
            BorderRadiusSize
                .borderRadius05, // Border radius for top left corner
          ),
          topRight: Radius.circular(
            BorderRadiusSize
                .borderRadius05, // Border radius for top right corner
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarHome, // Icon path for home tab
            AssetIconPath.homeBottomNavigatorBarHomeActive,
            // Active icon path for home tab
            LanguageKey.homeScreenBottomNavigatorBarHome,
            // Localization key for home tab label
            () {
              widget.onTabSelect(
                  0); // Callback function when home tab is selected
            },
            widget.currentIndex ==
                0, // Whether the home tab is currently selected
          ),
          _buildItem(
            AssetIconPath.homeBottomNavigatorBarHome, // Icon path for home tab
            AssetIconPath.homeBottomNavigatorBarHomeActive,
            // Active icon path for home tab
            LanguageKey.homeScreenBottomNavigatorBarHome,
            // Localization key for home tab label
            () {
              widget.onTabSelect(
                  1); // Callback function when home tab is selected
            },
            widget.currentIndex ==
                1, // Whether the home tab is currently selected
          ),
          _buildItem(
            AssetIconPath
                .homeBottomNavigatorBarAccount, // Icon path for account tab
            AssetIconPath.homeBottomNavigatorBarAccountActive,
            // Active icon path for account tab
            LanguageKey.homeScreenBottomNavigatorBarAccounts,
            // Localization key for account tab label
            () {
              widget.onTabSelect(
                  2); // Callback function when account tab is selected
            },
            widget.currentIndex ==
                2, // Whether the account tab is currently selected
          ),
          GestureDetector(
            onTap: widget
                .onScanTap, // Callback function when the scan button is tapped
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              AssetIconPath
                  .homeBottomNavigatorBarScan, // Icon path for scan button
            ),
          ),
          _buildItem(
            AssetIconPath
                .homeBottomNavigatorBarHistory, // Icon path for history tab
            AssetIconPath.homeBottomNavigatorBarHistoryActive,
            // Active icon path for history tab
            LanguageKey.homeScreenBottomNavigatorBarHistory,
            // Localization key for history tab label
            () {
              widget.onTabSelect(
                  3); // Callback function when history tab is selected
            },
            widget.currentIndex ==
                3, // Whether the history tab is currently selected
          ),
          _buildItem(
            AssetIconPath
                .homeBottomNavigatorBarSetting, // Icon path for setting tab
            AssetIconPath.homeBottomNavigatorBarSettingActive,
            // Active icon path for setting tab
            LanguageKey.homeScreenBottomNavigatorBarSetting,
            // Localization key for setting tab label
            () {
              widget.onTabSelect(
                  4); // Callback function when setting tab is selected
            },
            widget.currentIndex ==
                4, // Whether the setting tab is currently selected
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    String iconPath, // Icon path
    String activeIconPath, // Active icon path
    String labelPath, // Localization key for label
    VoidCallback onTap, // Callback function when the item is tapped
    bool isSelected, // Whether the item is currently selected
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
            isSelected
                ? activeIconPath
                : iconPath, // Display active icon if the item is selected, otherwise display normal icon
          ),
          const SizedBox(
            height: BoxSize.boxSize04, // Spacer height
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  labelPath, // Translate the label using localization provider
                ),
                style: AppTypoGraPhy.bodyMedium01.copyWith(
                  color: isSelected
                      ? widget.appTheme
                          .contentColorBrandDark // Text color for selected item
                      : widget.appTheme
                          .contentColor500, // Text color for normal item
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
