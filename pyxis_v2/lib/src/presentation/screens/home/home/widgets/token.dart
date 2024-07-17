import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/aura_util.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_v2/src/presentation/screens/home/home/home_page_selector.dart';
import 'package:pyxis_v2/src/presentation/widgets/box_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/combine_list_view.dart';
import 'package:pyxis_v2/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/network_image_widget.dart';

final class _HomePageTokenInfoWidget extends StatelessWidget {
  final String avatar;
  final String symbol;
  final String tokenName;
  final double percentChange24h;
  final double amount;
  final double value;
  final AppTheme appTheme;
  final AppLocalizationManager localization;

  const _HomePageTokenInfoWidget({
    required this.avatar,
    required this.symbol,
    required this.tokenName,
    required this.percentChange24h,
    required this.amount,
    required this.value,
    required this.appTheme,
    required this.localization,
    super.key,
  });

  Color valueChangeColor() {
    if (percentChange24h > 0) {
      return appTheme.utilityGreen500;
    } else if (percentChange24h == 0) {
      return appTheme.textSecondary;
    }

    return appTheme.utilityRed500;
  }

  bool get isIncrease => percentChange24h > 0;

  String prefixValueChange() {
    if (isIncrease) {
      return '+';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkImageWidget(
              url: avatar,
              appTheme: appTheme,
              cacheTarget: BoxSize.boxSize07,
              height: BoxSize.boxSize07,
              width: BoxSize.boxSize07,
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$symbol  ',
                          style: AppTypoGraPhy.textMdBold.copyWith(
                            color: appTheme.textPrimary,
                          ),
                        ),
                        TextSpan(
                          text:
                              '${prefixValueChange()}${percentChange24h.formatPercent}%',
                          style: AppTypoGraPhy.textXsMedium.copyWith(
                            color: valueChangeColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize02,
                  ),
                  Text(
                    tokenName,
                    style: AppTypoGraPhy.textXsMedium.copyWith(
                      color: appTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount.toString(),
                  style: AppTypoGraPhy.textMdBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  '${localization.translate(LanguageKey.commonBalancePrefix)}${value.formatPrice}',
                  style: AppTypoGraPhy.textXsMedium.copyWith(
                    color: appTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        HoLiZonTalDividerWidget(
          appTheme: appTheme,
        ),
      ],
    );
  }
}

final class HomePageTokensWidget extends StatelessWidget {
  final AppTheme appTheme;
  final AppLocalizationManager localization;

  const HomePageTokensWidget({
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.translate(
                    LanguageKey.homePageTotalValue,
                  ),
                  style: AppTypoGraPhy.textSmMedium
                      .copyWith(color: appTheme.textSecondary),
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  '${localization.translate(LanguageKey.commonBalancePrefix)}',
                  style: AppTypoGraPhy.textXlBold
                      .copyWith(color: appTheme.textPrimary),
                ),
              ],
            ),
            BoxBorderTextWidget(
              text: localization.translate(
                LanguageKey.homePageManage,
              ),
              borderColor: appTheme.borderSecondary,
              padding: const EdgeInsets.all(
                Spacing.spacing03,
              ),
              appTheme: appTheme,
              radius: BorderRadiusSize.borderRadius04,
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        Expanded(
          child: HomePageTokenMarketsSelector(builder: (tokenMarkets) {
            return HomePageAccountBalanceSelector(
              builder: (accountBalance) {
                if (accountBalance == null) {
                  return const SizedBox.shrink();
                }

                final balances = accountBalance.balances;
                return CombinedListView(
                  onRefresh: () {
                    //
                  },
                  onLoadMore: () {
                    //
                  },
                  data: balances,
                  builder: (balance, index) {
                    final token = tokenMarkets.firstWhereOrNull(
                      (t) => t.id == balance.tokenId,
                    );

                    final amount = double.tryParse(
                          balance.type.formatBalance(
                            balance.balance,
                            customDecimal: token?.decimal,
                          ),
                        ) ??
                        0;

                    double currentPrice =
                        double.tryParse(token?.currentPrice ?? '0') ?? 0;

                    double value = 0;
                    if (amount == 0 && currentPrice == 0) {
                      value = 0;
                    } else {
                      value = amount * currentPrice;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: Spacing.spacing05,
                      ),
                      child: _HomePageTokenInfoWidget(
                        avatar: token?.image ??
                            'https://aurascan.io/assets/images/logo/title-logo.png',
                        symbol: token?.symbol ?? '',
                        tokenName: token?.name ?? '',
                        percentChange24h: token?.priceChangePercentage24h ?? 0,
                        amount: amount,
                        value: value,
                        appTheme: appTheme,
                        localization: localization,
                      ),
                    );
                  },
                  canLoadMore: false,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
