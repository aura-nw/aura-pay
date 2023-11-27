import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class AccountCardWidget extends StatelessWidget {
  final String accountName;
  final String address;
  final AppTheme appTheme;

  const AccountCardWidget({
    required this.address,
    required this.accountName,
    super.key,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing06,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius05,
          ),
          gradient: LinearGradient(
            colors: [
              appTheme.surfaceColorBlack,
              const Color(
                0xff302E5C,
              ),
            ],
          )),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetIconPath.homeSmartAccountAvatarDefault,
          ),
          const SizedBox(
            width: BoxSize.boxSize05,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      accountName,
                      style: AppTypoGraPhy.heading02.copyWith(
                        color: appTheme.contentColorWhite,
                      ),
                    ),
                    const SizedBox(
                      width: BoxSize.boxSize04,
                    ),
                    SvgPicture.asset(
                      AssetIconPath.homeCopy,
                    ),
                  ],
                ),
                Text(
                  address,
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColor300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: BoxSize.boxSize05,
          ),
          SvgPicture.asset(
            AssetIconPath.homeArrowDown,
          ),
        ],
      ),
    );
  }
}
