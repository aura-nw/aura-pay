import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'browser_suggestion_widget.dart';

class GoogleSuggestionResultWidget extends BrowserSuggestionWidget {
  const GoogleSuggestionResultWidget({
    super.key,
    required super.description,
    required super.appTheme,
    required super.name,
    super.onTap,
  });

  @override
  Widget logoBuilder(BuildContext context, AppTheme appTheme) {
    return SvgPicture.asset(
      AssetIconPath.commonGoogle,
    );
  }
}
