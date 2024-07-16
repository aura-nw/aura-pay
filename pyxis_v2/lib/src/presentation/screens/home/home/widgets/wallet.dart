import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home/home_page_selector.dart';
import 'package:pyxis_v2/src/presentation/widgets/wallet_info_widget.dart';

class HomePageWalletCardWidget extends StatelessWidget {
  final AppTheme appTheme;
  final AppLocalizationManager localization;

  const HomePageWalletCardWidget({
    required this.appTheme,
    required this.localization,
    super.key,
  });

  Color valueChangeColor(double percent24hChange) {
    if (isIncrease(percent24hChange)) {
      return appTheme.utilityGreen500;
    } else if (percent24hChange == 0) {
      return appTheme.textSecondary;
    }

    return appTheme.utilityRed500;
  }

  bool  isIncrease(double percent24hChange) => percent24hChange > 0;

  String prefixValueChange(double percent24hChange){
    if(isIncrease(percent24hChange)){
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
          HomePageActiveAccountSelector(
            builder: (account) {
              return DefaultWalletInfoWidget(
                onCopy: (walletAddress) {},
                appTheme: appTheme,
                walletName: account?.name ?? '',
                walletAddress: account?.evmAddress ?? '',
              );
            }
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
            child: HomePageAuraMarketSelector(
              builder: (auraMarket) {
                return HomePageAccountBalanceSelector(
                  builder: (accountBalance) {
                    double totalValue = 0;
                    for(final balance in accountBalance?.balances ?? <Balance>[]){
                      final amount =
                          double.tryParse(balance.balance) ?? 0;

                      double currentPrice = double.tryParse(
                          auraMarket?.currentPrice ?? '0') ??
                          0;


                      if(amount != 0 || currentPrice != 0){
                        totalValue += amount * currentPrice;
                      }
                    }
                    return Column(
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
                                  color: valueChangeColor(auraMarket?.priceChangePercentage24h ?? 0.0),
                                ),
                                text: '${prefixValueChange(auraMarket?.priceChangePercentage24h ?? 0.0)}${totalValue * (auraMarket?.priceChangePercentage24h ?? 0.0) }(${prefixValueChange(auraMarket?.priceChangePercentage24h ?? 0.0)}${auraMarket?.priceChangePercentage24h ?? 0.0})%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
