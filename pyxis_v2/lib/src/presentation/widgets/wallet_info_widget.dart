import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/core/constants/app_local_constant.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_v2/src/presentation/widgets/circle_avatar_widget.dart';

abstract class WalletInfoWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String walletName;
  final String walletAddress;

  const WalletInfoWidget({
    required this.appTheme,
    required this.walletName,
    required this.walletAddress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        avatar(context),
        const SizedBox(
          width: BoxSize.boxSize05,
        ),
        Expanded(
          child: content(context),
        ),
        const SizedBox(
          width: BoxSize.boxSize05,
        ),
        actions(context),
      ],
    );
  }

  Widget avatar(
    BuildContext context,
  );

  Widget actions(
    BuildContext context,
  );

  Widget content(BuildContext context);
}

final class DefaultWalletInfoWidget extends WalletInfoWidget {
  final void Function(String) onCopy;

  const DefaultWalletInfoWidget({
    super.key,
    required this.onCopy,
    required super.appTheme,
    required super.walletName,
    required super.walletAddress,
  });

  String randomAvatar() {
    Random random = Random(128);

    int index = random.nextInt(2);

    return AppLocalConstant.avatars[index];
  }

  @override
  Widget actions(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.icCommonArrowDown,
    );
  }

  @override
  Widget avatar(BuildContext context) {
    return CircleAvatarWidget(
      image: AssetImage(
        randomAvatar(),
      ),
      radius: BorderRadiusSize.borderRadius04,
    );
  }

  @override
  Widget content(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onCopy(walletAddress);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            walletName,
            style:
                AppTypoGraPhy.textMdBold.copyWith(color: appTheme.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: BoxSize.boxSize02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                walletAddress.addressView,
                style: AppTypoGraPhy.textSmMedium.copyWith(
                  color: appTheme.textSecondary,
                ),
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              SvgPicture.asset(
                AssetIconPath.icCommonCopy,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
