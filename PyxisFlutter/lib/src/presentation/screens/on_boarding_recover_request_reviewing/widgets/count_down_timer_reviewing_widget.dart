import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

class CountDownTimerReviewingWidget extends StatelessWidget {
  final int duration;
  final AppTheme appTheme;

  const CountDownTimerReviewingWidget({
    required this.duration,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: AppTypoGraPhy.heading05.copyWith(
            color: appTheme.contentColor700,
          ),
          children: [
            TextSpan(
              children: [
                TextSpan(
                  text: duration.toHours,
                ),
                TextSpan(
                  text: ' h    ',
                  style: AppTypoGraPhy.body04.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            ),
            TextSpan(
              children: [
                TextSpan(
                  text: duration.toMinutes,
                ),
                TextSpan(
                  text: ' m    ',
                  style: AppTypoGraPhy.body04.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            ),
            TextSpan(
              children: [
                TextSpan(
                  text: duration.toSeconds,
                ),
                TextSpan(
                  text: ' s    ',
                  style: AppTypoGraPhy.body04.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
