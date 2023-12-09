import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/app_date_format.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

class TransactionInformationFormWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String sender;
  final String recipient;
  final String time;
  final String txHash;
  final VoidCallback onCopy;

  const TransactionInformationFormWidget({
    required this.appTheme,
    required this.sender,
    required this.recipient,
    required this.time,
    required this.txHash,
    required this.onCopy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing06,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayDefault,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius05,
        ),
      ),
      child: Column(
        children: [
          _buildLineTransaction(
            LanguageKey.sendTransactionResultScreenFrom,
            sender.addressView,
          ),
          _buildLineTransaction(
            LanguageKey.sendTransactionResultScreenRecipient,
            recipient.addressView,
          ),
          _buildLineTransaction(
            LanguageKey.sendTransactionResultScreenTimeCreated,
            AppDateTime.formatDateHHMMDMMMYYY(
              time,
            ),
          ),
          _buildTxHash(
            txHash.addressView,
          ),
        ],
      ),
    );
  }

  Widget _buildLineTransaction(String titleKey, String value) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  titleKey,
                ),
                style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          Text(
            value,
            style: AppTypoGraPhy.body03.copyWith(
              color: appTheme.contentColorBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTxHash(String value) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.sendTransactionResultScreenHash,
                ),
                style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          Row(
            children: [
              Text(
                value,
                style: AppTypoGraPhy.body03.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              ),
              const SizedBox(
                width: BoxSize.boxSize03,
              ),
              GestureDetector(
                onTap: onCopy,
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  AssetIconPath.sendSuccessfulCopy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
