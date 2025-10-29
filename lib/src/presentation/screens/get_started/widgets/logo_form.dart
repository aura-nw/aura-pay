import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/core/constants/asset_path.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';

/// Logo and app name display widget for Get Started screen.
///
/// Shows the app logo and wallet name centered on screen.
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
      children: [
        SvgPicture.asset(AssetLogoPath.logo),
        const SizedBox(height: BoxSize.boxSize07),
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

