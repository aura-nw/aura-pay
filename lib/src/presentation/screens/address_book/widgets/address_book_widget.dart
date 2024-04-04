import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class AddressBookWidget extends StatelessWidget {
  final String name;
  final String address;
  final AppTheme appTheme;
  final VoidCallback onTap;

  const AddressBookWidget({
    required this.name,
    required this.address,
    required this.appTheme,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypoGraPhy.heading02.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  address,
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: BoxSize.boxSize05,
          ),
          SvgPicture.asset(
            AssetIconPath.commonMore,
          ),
        ],
      ),
    );
  }
}
