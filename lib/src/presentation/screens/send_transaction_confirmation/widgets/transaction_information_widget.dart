import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction_confirmation/send_transaction_confirmation_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

abstract class _TransactionInformationBaseWidget extends StatelessWidget {
  final String titleKey;
  final String information;
  final AppTheme appTheme;

  const _TransactionInformationBaseWidget({
    super.key,
    required this.titleKey,
    required this.information,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          titleBuilder(context),
          informationBuilder(
            context,
          ),
        ],
      ),
    );
  }

  Widget titleBuilder(
    BuildContext context,
  ) {
    return AppLocalizationProvider(
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
    );
  }

  Widget informationBuilder(
    BuildContext context,
  ) {
    return Text(
      information,
      style: AppTypoGraPhy.body03.copyWith(
        color: appTheme.contentColorBlack,
      ),
    );
  }
}

final class _TransactionInformationFeeWidget
    extends _TransactionInformationBaseWidget {
  final VoidCallback onEditFee;

  const _TransactionInformationFeeWidget({
    required this.onEditFee,
    required super.titleKey,
    required super.information,
    required super.appTheme,
  });

  @override
  Widget informationBuilder(BuildContext context) {
    return Row(
      children: [
        Text(
          information,
          style: AppTypoGraPhy.body03.copyWith(
            color: appTheme.contentColorBlack,
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onEditFee,
          child: SvgPicture.asset(
            AssetIconPath.commonFeeEdit,
          ),
        ),
      ],
    );
  }
}

final class _TransactionInformationWidget
    extends _TransactionInformationBaseWidget {
  const _TransactionInformationWidget({
    required super.titleKey,
    required super.information,
    required super.appTheme,
  });
}

final class TransactionInformationWidget extends StatelessWidget {
  final String from;
  final String accountName;
  final String recipient;
  final String amount;
  final AppTheme appTheme;
  final VoidCallback onEditFee;

  const TransactionInformationWidget({
    required this.accountName,
    required this.amount,
    required this.from,
    required this.recipient,
    required this.appTheme,
    required this.onEditFee,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.sendTransactionConfirmationScreenTotal,
              ),
              style: AppTypoGraPhy.heading02.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize02,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return SendTransactionConfirmationAmountSelector(
              builder: (amount) {
                double amountD = double.tryParse(amount) ?? 0;
                return SendTransactionConfirmationFeeSelector(
                  builder: (fee) {
                    double feeD = double.tryParse(fee.formatAura) ?? 0;
                    return Text(
                      '${(amountD + feeD).formatAuraNumber} ${localization.translate(
                        LanguageKey.globalPyxisAura,
                      )}',
                      style: AppTypoGraPhy.heading04.copyWith(
                        color: appTheme.contentColorBrand,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        const DividerSeparator(),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        _TransactionInformationWidget(
          titleKey: LanguageKey.sendTransactionConfirmationScreenSendFrom,
          information: '${from.addressView} ($accountName)',
          appTheme: appTheme,
        ),
        _TransactionInformationWidget(
          titleKey: LanguageKey.sendTransactionConfirmationScreenRecipient,
          information: recipient.addressView,
          appTheme: appTheme,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return _TransactionInformationWidget(
              titleKey: LanguageKey.sendTransactionConfirmationScreenAmount,
              information: '$amount ${localization.translate(
                LanguageKey.globalPyxisAura,
              )}',
              appTheme: appTheme,
            );
          },
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return SendTransactionConfirmationFeeSelector(
              builder: (fee) {
                return _TransactionInformationFeeWidget(
                  onEditFee: onEditFee,
                  titleKey: LanguageKey.sendTransactionConfirmationScreenFee,
                  information: '${fee.formatAura} ${localization.translate(
                    LanguageKey.globalPyxisAura,
                  )}',
                  appTheme: appTheme,
                );
              },
            );
          },
        )
      ],
    );
  }
}
