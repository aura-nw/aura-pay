import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/presentation/widgets/wallet_info_widget.dart';

final class HomeWalletReceiveWidget extends StatelessWidget {
  final String logo;
  final String type;
  final String address;
  final AppTheme appTheme;

  const HomeWalletReceiveWidget({
    required this.appTheme,
    required this.type,
    required this.address,
    required this.logo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WalletInfoWithCustomActionsWidget(
      avatarAsset: logo,
      appTheme: appTheme,
      title: type,
      address: address,
      action: Row(
        children: [
          SvgPicture.asset(
            AssetIconPath.icCommonShare,
          ),
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          SvgPicture.asset(
            AssetIconPath.icCommonCopy,
          ),
        ],
      ),
    );
  }
}
