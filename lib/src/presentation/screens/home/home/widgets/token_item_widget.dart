import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class TokenItemWidget extends StatelessWidget {
  final String iconPath;
  final String coin;
  final String coinId;
  final String balance;
  final String price;
  final AppTheme appTheme;

  const TokenItemWidget({
    required this.iconPath,
    required this.coin,
    required this.coinId,
    required this.appTheme,
    required this.price,
    required this.balance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
        ),
        const SizedBox(
          width: BoxSize.boxSize03,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coin,
                style: AppTypoGraPhy.heading01.copyWith(
                  color: appTheme.contentColor500,
                ),
              ),
              const SizedBox(
                height: BoxSize.boxSize02,
              ),
              Text(
                coinId,
                style: AppTypoGraPhy.body01.copyWith(
                  color: appTheme.contentColor700,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              balance,
              style: AppTypoGraPhy.heading01.copyWith(
                color: appTheme.contentColor500,
              ),
            ),
            const SizedBox(
              height: BoxSize.boxSize02,
            ),
            Text(
              price,
              style: AppTypoGraPhy.body01.copyWith(
                color: appTheme.contentColor700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
