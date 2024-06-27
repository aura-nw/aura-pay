import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';

class BrowserTabManagementBottomWidget extends StatelessWidget {
  final VoidCallback onCloseAll;
  final VoidCallback onAddNewTab;
  final AppTheme appTheme;

  const BrowserTabManagementBottomWidget({
    required this.onAddNewTab,
    required this.onCloseAll,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing06,
        vertical: Spacing.spacing05,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorWhite,
        border: Border(
          top: BorderSide(
            color: appTheme.borderColorGrayDefault,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCloseAll,
            child: IconWithTextWidget(
              titlePath: LanguageKey.browserManagementScreenCloseAll,
              svgIconPath: AssetIconPath.commonClose,
              appTheme: appTheme,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAddNewTab,
            child: IconWithTextWidget(
              titlePath: LanguageKey.browserManagementScreenNewTab,
              svgIconPath: AssetIconPath.commonAdd,
              appTheme: appTheme,
            ),
          ),
        ],
      ),
    );
  }
}
