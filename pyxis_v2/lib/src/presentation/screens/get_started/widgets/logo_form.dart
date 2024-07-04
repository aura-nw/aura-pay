import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';

class GetStartedLogoFormWidget extends StatelessWidget {
  final String walletName;
  final AppTheme appTheme;

  const GetStartedLogoFormWidget({
    required this.walletName,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetLogoPath.logo,
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        Text(
          walletName,
          style: AppTypoGraPhy.displayXsRegular.copyWith(
            color: appTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
