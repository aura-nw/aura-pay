import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'package:pyxis_mobile/src/core/utils/app_date_format.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';

class TransactionWidget extends StatelessWidget {
  final bool status;
  final Map<String,dynamic> msg;
  final String time;
  final AppTheme appTheme;
  final VoidCallback onTap;
  final String address;
  final String accountName;

  const TransactionWidget({
    required this.status,
    required this.msg,
    required this.time,
    required this.appTheme,
    required this.onTap,
    required this.accountName,
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MsgType msgType = TransactionHelper.getMsgType(msg);

    if(msgType == MsgType.other){
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: Spacing.spacing08,
        ),
        child: _buildTransactionWithType(msgType, context),
      ),
    );
  }

  Widget _buildTransactionWithType(MsgType msgType, BuildContext context) {
    switch (msgType) {
      case MsgType.send:
        final MsgSend msgSend = TransactionHelper.parseMsgSend(msg);

        bool isSend = msgSend.fromAddress == address;

        String type = AppLocalizationManager.of(context).translate(
          LanguageKey.transactionHistoryPageReceive,
        );

        String iconPath = AssetIconPath.historyReceiveLogo;

        if (isSend) {
          type = AppLocalizationManager.of(context).translate(
            LanguageKey.transactionHistoryPageSend,
          );

          iconPath = AssetIconPath.historySendLogo;
        }

        return Row(
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
                            '${msgSend.amount[0].amount.formatAura} ${localization.translate(
                              LanguageKey.globalPyxisAura,
                            )}',
                            style: AppTypoGraPhy.bodyMedium02.copyWith(
                              color: !isSend
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
                      Text(
                        AppDateTime.formatDateTimeHHmmWithAMPM(time),
                        style: AppTypoGraPhy.body02.copyWith(
                          color: appTheme.contentColor500,
                        ),
                      ),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      case MsgType.executeContract:
        final MsgExecuteContract msgExecuteContract =
            TransactionHelper.parseMsgExecuteContract(msg);

        return Row(
          children: [
            SvgPicture.asset(
              AssetIconPath.historySetRecoveryLogo,
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizationManager.of(context).translate(
                      LanguageKey.transactionHistoryPageSetRecovery,
                    ),
                    style: AppTypoGraPhy.heading01.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize04,
                  ),
                  Text(
                    AppDateTime.formatDateTimeHHmmWithAMPM(time),
                    style: AppTypoGraPhy.body02.copyWith(
                      color: appTheme.contentColor500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case MsgType.recover:
        return Row(
          children: [
            SvgPicture.asset(
              AssetIconPath.historyRecoveryLogo,
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizationManager.of(context).translate(
                      LanguageKey.transactionHistoryPageRecovery,
                    ),
                    style: AppTypoGraPhy.heading01.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize04,
                  ),
                  Text(
                    AppDateTime.formatDateTimeHHmmWithAMPM(time),
                    style: AppTypoGraPhy.body02.copyWith(
                      color: appTheme.contentColor500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case MsgType.other:
        return const SizedBox.shrink();
    }
  }
}
