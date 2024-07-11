import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/presentation/widgets/wallet_info_widget.dart';

class HomePageWalletCardWidget extends StatelessWidget {
  final String walletName;
  final String walletAddress;
  final AppTheme appTheme;
  final AppLocalizationManager localization;
  final String totalValue;
  final double value24hChange;
  final double percent24hChange;

  const HomePageWalletCardWidget({
    required this.walletAddress,
    required this.walletName,
    required this.appTheme,
    required this.localization,
    this.totalValue = '0.0',
    this.percent24hChange = 0,
    this.value24hChange = 0,
    super.key,
  });

  Color valueChangeColor() {
    if (percent24hChange > 0) {
      return appTheme.utilityGreen500;
    } else if (percent24hChange == 0) {
      return appTheme.textSecondary;
    }

    return appTheme.utilityRed500;
  }

  bool get isIncrease => percent24hChange > 0;

  String prefixValueChange(){
    if(isIncrease){
      return '+';
    }

    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing05,
      ),
      decoration: BoxDecoration(
        color: appTheme.bgBrandPrimary,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius05,
        ),
      ),
      child: Column(
        children: [
          DefaultWalletInfoWidget(
            onCopy: (walletAddress) {},
            appTheme: appTheme,
            walletName: walletName,
            walletAddress: walletAddress,
          ),
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Spacing.spacing04,
              horizontal: Spacing.spacing05,
            ),
            decoration: BoxDecoration(
              color: appTheme.bgPrimary,
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius04,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localization.translate(
                        LanguageKey.homePageTotalValue,
                      ),
                      style: AppTypoGraPhy.textSmMedium.copyWith(
                        color: appTheme.textTertiary,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetIconPath.icCommonEye,
                        ),
                        const SizedBox(
                          width: BoxSize.boxSize04,
                        ),
                        SvgPicture.asset(
                          AssetIconPath.icCommonScan,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: BoxSize.boxSize03,
                ),
                Text(
                  '${localization.translate(LanguageKey.commonBalancePrefix)}$totalValue',
                  style: AppTypoGraPhy.displayXsSemiBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize03,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        style: AppTypoGraPhy.textXsMedium.copyWith(
                          color: appTheme.textSecondary,
                        ),
                        text: '${localization.translate(
                          LanguageKey.homePage24hPNL,
                        )}  ',
                      ),
                      TextSpan(
                        style: AppTypoGraPhy.textXsMedium.copyWith(
                          color: valueChangeColor(),
                        ),
                        text: '${prefixValueChange()}$value24hChange(${prefixValueChange()}$percent24hChange)%',
                      ),
                    ],
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
