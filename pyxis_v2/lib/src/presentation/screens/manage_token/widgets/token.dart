import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/switch_widget.dart';

final class ManageTokenScreenTokenWidget extends StatelessWidget {
  final String logo;
  final String name;
  final String networkName;
  final bool isEnable;
  final void Function(bool) onChanged;
  final AppTheme appTheme;

  const ManageTokenScreenTokenWidget({
    required this.name,
    required this.logo,
    required this.networkName,
    required this.onChanged,
    required this.isEnable,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    name,
                    style: AppTypoGraPhy.textMdBold.copyWith(
                      color: appTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize02,
                  ),
                  Text(
                    networkName,
                    style: AppTypoGraPhy.textXsMedium.copyWith(
                      color: appTheme.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            SwitchWidget(
              onChanged: onChanged,
              isSelected: isEnable,
              appTheme: appTheme,
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        HoLiZonTalDividerWidget(
          appTheme: appTheme,
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
      ],
    );
  }
}

class ManageTokenScreenTokensWidget extends StatelessWidget {
  final AppTheme appTheme;
  final AppLocalizationManager localization;

  const ManageTokenScreenTokensWidget({
    required this.appTheme,
    required this.localization,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localization.translate(
                LanguageKey.manageTokenScreenShowTitle,
              ),
              style: AppTypoGraPhy.textMdSemiBold.copyWith(
                color: appTheme.textPrimary,
              ),
            ),
            SvgPicture.asset(
              AssetIconPath.icCommonFilter,
            ),
          ],
        ),
      ],
    );
  }
}
