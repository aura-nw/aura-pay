import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser/browser_selector.dart';

class BrowserBottomNavigatorWidget extends StatelessWidget {
  final AppTheme appTheme;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onBookmarkClick;
  final VoidCallback onHomeClick;
  final void Function(
    List<AuraAccount>,
    AuraAccount?,
  ) onAccountClick;

  const BrowserBottomNavigatorWidget({
    required this.appTheme,
    required this.onNext,
    required this.onBack,
    required this.onBookmarkClick,
    required this.onHomeClick,
    required this.onAccountClick,
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
              AssetIconPath.inAppBrowserBack,
            ),
          ),
          BrowserCanGoNextSelector(
            builder: (canGoNext) {
              return GestureDetector(
                onTap: onNext,
                behavior: HitTestBehavior.opaque,
                child: canGoNext
                    ? SvgPicture.asset(
                        AssetIconPath.inAppBrowserNextBold,
                      )
                    : SvgPicture.asset(
                        AssetIconPath.inAppBrowserNext,
                      ),
              );
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onHomeClick,
            child: SvgPicture.asset(
              AssetIconPath.inAppBrowserLogo,
            ),
          ),
          GestureDetector(
            onTap: onBookmarkClick,
            behavior: HitTestBehavior.opaque,
            child: BrowserBookMarkSelector(
              builder: (bookMark) {
                return bookMark != null
                    ? SvgPicture.asset(
                        AssetIconPath.inAppBrowserBookMarkActive,
                      )
                    : SvgPicture.asset(
                        AssetIconPath.inAppBrowserBookMark,
                      );
              },
            ),
          ),
          BrowserAccountsSelector(
            builder: (accounts) {
              return BrowserSelectedAccountSelector(builder: (selectedAccount) {
                return GestureDetector(
                  onTap: () {
                    onAccountClick(accounts, selectedAccount);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    AssetIconPath.inAppBrowserAccount,
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
