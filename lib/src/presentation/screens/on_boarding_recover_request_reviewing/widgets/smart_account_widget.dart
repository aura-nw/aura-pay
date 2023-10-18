import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/circular_avatar_widget.dart';

class SmartAccountWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String avatar;
  final String smartAccountName;
  final String smartAccountAddress;

  const SmartAccountWidget({
    required this.appTheme,
    required this.smartAccountAddress,
    required this.smartAccountName,
    required this.avatar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
        color: appTheme.surfaceColorBrandLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircularAvatarWidget(
            image: NetworkImage(
              avatar,
            ),
            radius: BorderRadiusSize.borderRadiusRound,
          ),
          const SizedBox(
            width: BoxSize.boxSize05,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  smartAccountName,
                  style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  smartAccountAddress,
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
