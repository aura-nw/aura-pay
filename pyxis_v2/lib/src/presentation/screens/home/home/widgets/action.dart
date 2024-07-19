import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/presentation/widgets/box_widget.dart';

final class HomePageActionWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String title;
  final String svg;
  final Color? bgColor;

  const HomePageActionWidget({
    required this.appTheme,
    required this.title,
    required this.svg,
    this.bgColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BoxIconWidget(
          svg: svg,
          height: BoxSize.boxSize10,
          width: BoxSize.boxSize10,
          color: bgColor,
          padding: const EdgeInsets.all(
            Spacing.spacing04,
          ),
          appTheme: appTheme,
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        Text(
          title,
          style: AppTypoGraPhy.textXsSemiBold.copyWith(
            color: appTheme.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

final class HomePageActionsWidget extends StatelessWidget {
  final AppTheme appTheme;
  final AppLocalizationManager localization;

  const HomePageActionsWidget({
    required this.appTheme,
    required this.localization,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HomePageActionWidget(
            appTheme: appTheme,
            title: localization.translate(
              LanguageKey.homePageSend,
            ),
            svg: AssetIconPath.icCommonSend,
            bgColor: appTheme.utilityBlue100,
          ),
          HomePageActionWidget(
            appTheme: appTheme,
            title: localization.translate(
              LanguageKey.homePageReceive,
            ),
            svg: AssetIconPath.icCommonReceive,
            bgColor: appTheme.utilityGreen100,
          ),
          HomePageActionWidget(
            appTheme: appTheme,
            title: localization.translate(
              LanguageKey.homePageSwap,
            ),
            svg: AssetIconPath.icCommonSwap,
            bgColor: appTheme.utilityPink100,
          ),
          HomePageActionWidget(
            appTheme: appTheme,
            title: localization.translate(
              LanguageKey.homePageStake,
            ),
            svg: AssetIconPath.icCommonStake,
            bgColor: appTheme.utilityOrange100,
          ),
        ],
      ),
    );
  }
}

final class HomePageActionsSmallWidget extends StatelessWidget {
  final AppTheme appTheme;

  const HomePageActionsSmallWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BoxIconWidget(
          appTheme: appTheme,
          svg: AssetIconPath.icCommonSend,
          color: appTheme.utilityBlue100,
          padding: const EdgeInsets.all(
            Spacing.spacing04,
          ),
          icWidth: BoxSize.boxSize05,
        ),
        BoxIconWidget(
          appTheme: appTheme,
          svg: AssetIconPath.icCommonReceive,
          color: appTheme.utilityGreen100,
          padding: const EdgeInsets.all(
            Spacing.spacing04,
          ),
          icWidth: BoxSize.boxSize05,
        ),
        BoxIconWidget(
          appTheme: appTheme,
          svg: AssetIconPath.icCommonSwap,
          color: appTheme.utilityPink100,
          padding: const EdgeInsets.all(
            Spacing.spacing04,
          ),
          icWidth: BoxSize.boxSize05,
        ),
        BoxIconWidget(
          appTheme: appTheme,
          svg: AssetIconPath.icCommonStake,
          color: appTheme.utilityOrange100,
          padding: const EdgeInsets.all(
            Spacing.spacing04,
          ),
          icWidth: BoxSize.boxSize05,
        ),
      ],
    );
  }
}
