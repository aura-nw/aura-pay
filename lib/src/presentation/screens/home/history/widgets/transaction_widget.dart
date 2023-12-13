import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/app_date_format.dart';

class TransactionWidget extends StatelessWidget {
  final String type;
  final String iconPath;
  final bool status;
  final String amount;
  final String time;
  final AppTheme appTheme;
  final bool isReceive;
  final VoidCallback onTap;

  const TransactionWidget({
    required this.type,
    required this.iconPath,
    required this.status,
    required this.amount,
    required this.time,
    required this.appTheme,
    required this.isReceive,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: Spacing.spacing08,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type,
                        style: AppTypoGraPhy.heading01.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            '$amount ${localization.translate(
                              LanguageKey.globalPyxisAura,
                            )}',
                            style: AppTypoGraPhy.bodyMedium02.copyWith(
                              color: isReceive
                                  ? appTheme.contentColorSuccess
                                  : appTheme.contentColorBlack,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppLocalizationProvider(builder: (localization, _) {
                        return Text(
                          status
                              ? localization.translate(
                                  LanguageKey
                                      .transactionHistoryPageTransactionStatusSuccess,
                                )
                              : localization.translate(
                                  LanguageKey
                                      .transactionHistoryPageTransactionStatusFail,
                                ),
                          style: AppTypoGraPhy.body01.copyWith(
                            color: status
                                ? appTheme.contentColorSuccess
                                : appTheme.contentColorDanger,
                          ),
                        );
                      }),
                      Text(
                        AppDateTime.formatDateTimeHHmmWithAMPM(time),
                        style: AppTypoGraPhy.body02.copyWith(
                          color: appTheme.contentColor500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
