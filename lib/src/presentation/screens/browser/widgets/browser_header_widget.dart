import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser/browser_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';

class BrowserHeaderWidget extends StatelessWidget {
  final AppTheme appTheme;
  final VoidCallback onViewTap;
  final VoidCallback onSearchTap;
  final String url;
  final VoidCallback onShareTap;
  final VoidCallback onAddNewTab;
  final VoidCallback onRefresh;

  const BrowserHeaderWidget({
    required this.appTheme,
    required this.onViewTap,
    required this.onSearchTap,
    required this.url,
    required this.onShareTap,
    required this.onAddNewTab,
    required this.onRefresh,
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
              horizontal: Spacing.spacing02,
            ),
            child: BrowserTabCountSelector(builder: (tabCount) {
              return Text(
                tabCount.toString(),
                style: AppTypoGraPhy.heading01.copyWith(
                  color: appTheme.contentColor700,
                ),
                textAlign: TextAlign.center,
              );
            }),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Spacing.spacing04,
            ),
            child: PopupMenuButton(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  BorderRadiusSize.borderRadius04,
                ),
              ),
              color: appTheme.surfaceColorWhite,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    onTap: onAddNewTab,
                    child: _BrowserPopupMenuItemWidget(
                      titlePath: LanguageKey.inAppBrowserScreenNewTab,
                      svgIconPath: AssetIconPath.commonAdd,
                      appTheme: appTheme,
                    ),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    onTap: onShareTap,
                    child: _BrowserPopupMenuItemWidget(
                      titlePath: LanguageKey.inAppBrowserScreenShare,
                      svgIconPath: AssetIconPath.commonShare,
                      appTheme: appTheme,
                    ),
                  ),
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    onTap: onRefresh,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HoLiZonTalDividerWidget(),
                        const SizedBox(
                          height: BoxSize.boxSize05,
                        ),
                        _BrowserPopupMenuItemWidget(
                          titlePath: LanguageKey.inAppBrowserScreenRefresh,
                          svgIconPath: AssetIconPath.commonRefresh,
                          appTheme: appTheme,
                        ),
                      ],
                    ),
                  ),
                ];
              },
              child: SvgPicture.asset(
                AssetIconPath.commonMore,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final class _BrowserPopupMenuItemWidget extends StatelessWidget {
  final String titlePath;
  final String svgIconPath;
  final AppTheme appTheme;

  const _BrowserPopupMenuItemWidget({
    required this.titlePath,
    required this.svgIconPath,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w * 0.45,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.spacing04,
        ),
        child: IconWithTextWidget(
          titlePath: titlePath,
          svgIconPath: svgIconPath,
          appTheme: appTheme,
        ),
      ),
    );
  }
}
