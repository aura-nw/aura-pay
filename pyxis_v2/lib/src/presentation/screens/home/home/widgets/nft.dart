import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';

class HomePageNFTCardWidget extends StatelessWidget {
  final String thumbnail;
  final String name;
  final String createTime;
  final String price;
  final String id;
  final AppTheme appTheme;

  const HomePageNFTCardWidget(
      {required this.id,
      required this.name,
      required this.createTime,
      required this.price,
      required this.thumbnail,
      required this.appTheme,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppTypoGraPhy.textMdBold.copyWith(
                  color: appTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            Text(
              id,
              style: AppTypoGraPhy.textSmRegular.copyWith(
                color: appTheme.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
