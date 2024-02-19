import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class SearchWidget extends StatelessWidget {
  final AppTheme appTheme;
  final int tabCount;
  final VoidCallback onViewTap;
  final VoidCallback onSearchTap;

  const SearchWidget({
    required this.appTheme,
    this.tabCount = 0,
    required this.onViewTap,
    required this.onSearchTap,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.inAppBrowserPagePlaceHolder,
                        ),
                        style: AppTypoGraPhy.body03.copyWith(
                          color: appTheme.contentColor300,
                        ),
                      );
                    },
                  ),
                  SvgPicture.asset(
                    AssetIconPath.commonSearch,
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
                color: appTheme.borderColorBlack,
                width: BoxSize.boxSize01
              ),
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius01,
              ),
            ),
            padding: const EdgeInsets.all(
              Spacing.spacing01,
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
