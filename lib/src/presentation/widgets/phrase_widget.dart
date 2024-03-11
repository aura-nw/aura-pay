import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class PhraseWidget extends StatelessWidget {
  final String word;
  final int position;
  final AppTheme appTheme;

  const PhraseWidget({
    required this.position,
    required this.word,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${position.toString()}.',
          style: AppTypoGraPhy.body02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize01,
        ),
        Container(
          padding: const EdgeInsets.all(
            Spacing.spacing03,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadius03,
            ),
            color: appTheme.surfaceColorGrayLight,
          ),
          child: Text(
            word,
            style: AppTypoGraPhy.body02.copyWith(
              color: appTheme.contentColorBlack,
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
