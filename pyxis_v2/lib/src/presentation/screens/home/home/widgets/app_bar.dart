import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home/home_page_selector.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home/widgets/action.dart';
import 'package:pyxis_v2/src/presentation/widgets/circle_avatar_widget.dart';

final class HomeAppBar extends StatelessWidget {
  final AppLocalizationManager localization;
  final AppTheme appTheme;
  final bool showActions;
  final bool showWallet;
  final VoidCallback onActionClick;
  final String avatarAsset;

  const HomeAppBar({
    required this.appTheme,
    required this.localization,
    this.showActions = false,
    this.showWallet = false,
    required this.onActionClick,
    required this.avatarAsset,
    super.key,
  });

  bool get showTitleAndWallet => showWallet && !showActions;

  bool get showAppBarSmall => showWallet && showActions;

  @override
  Widget build(BuildContext context) {
    return HomePageNetworksSelector(
      builder: (networks) {
        return HomePageIsAllNetworkSelector(
          builder: (isAllNetwork) {
            if (showAppBarSmall) {
              return _appBarSmall();
            } else if (showTitleAndWallet) {
              return _appBarWithWalletCardSmall();
            }
            return _defaultAppBar();
          },
        );
      },
    );
  }

  Widget _buildSmallTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing03,
        vertical: Spacing.spacing02,
      ),
      decoration: BoxDecoration(
        color: appTheme.bgTertiary,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetIconPath.icCommonAllNetwork,
          ),
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          SvgPicture.asset(
            AssetIconPath.icCommonArrowDown,
          ),
        ],
      ),
    );
  }

  Widget _defaultAppBar() {
    return _titleDefault();
  }

  Widget _titleDefault() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetIconPath.icCommonAllNetwork,
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        Text(
          localization.translate(
            LanguageKey.homePageAllNetwork,
          ),
          style: AppTypoGraPhy.textSmSemiBold.copyWith(
            color: appTheme.textPrimary,
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        SvgPicture.asset(
          AssetIconPath.icCommonArrowDown,
        ),
      ],
    );
  }

  Widget _appBarSmall() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _buildSmallTitle(),
                const SizedBox(
                  width: BoxSize.boxSize04,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onActionClick,
                  child: Row(
                    children: [
                      CircleAvatarWidget(
                        image: AssetImage(
                          avatarAsset,
                        ),
                        radius: BorderRadiusSize.borderRadius04,
                      ),
                      const SizedBox(
                        width: BoxSize.boxSize04,
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: appTheme.borderSecondary,
                  thickness: DividerSize.divider01,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onActionClick,
              child: HomePageActionsSmallWidget(
                appTheme: appTheme,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarWithWalletCardSmall() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _titleDefault(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onActionClick,
          child: Row(
            children: [
              CircleAvatarWidget(
                image: AssetImage(
                  avatarAsset,
                ),
                radius: BorderRadiusSize.borderRadius04,
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
