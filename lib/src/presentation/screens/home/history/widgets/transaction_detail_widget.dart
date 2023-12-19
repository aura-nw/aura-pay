import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/aura_scan.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/app_launcher.dart';
import 'package:pyxis_mobile/src/core/helpers/transaction_helper.dart';
import 'package:pyxis_mobile/src/core/utils/app_date_format.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/set_recovery_method/widgets/account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';

class TransactionDetailWidget extends StatelessWidget {
  final AppTheme appTheme;
  final PyxisTransaction pyxisTransaction;
  final String address;
  final String accountName;

  const TransactionDetailWidget({
    required this.appTheme,
    required this.pyxisTransaction,
    required this.address,
    required this.accountName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MsgType msgType = TransactionHelper.getMsgType(pyxisTransaction.msg);
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
        top: Spacing.spacing04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScrollViewWidget(
            appTheme: appTheme,
          ),
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          _buildTransactionWithType(
            msgType,
            context,
          ),
          const SizedBox(
            height: BoxSize.boxSize03,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return TextAppButton(
                onPress: () {
                  AppLauncher.launch(
                    AuraScan.transaction(
                      pyxisTransaction.txHash,
                    ),
                  );
                },
                text: localization.translate(
                  LanguageKey.transactionHistoryPageViewOnAuraScan,
                ),
                style: AppTypoGraPhy.bodyMedium03.copyWith(
                  color: appTheme.contentColorBrand,
                ),
                suffix: SvgPicture.asset(
                  AssetIconPath.commonCopyActive,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTransactionWithType(MsgType msgType, BuildContext context) {
    switch (msgType) {
      case MsgType.send:
        final MsgSend msgSend =
            TransactionHelper.parseMsgSend(pyxisTransaction.msg);

        bool isSend = msgSend.fromAddress == address;

        if (isSend) {
          return _buildSendWidget(msgSend, context);
        }

        return _buildReceiveWidget(msgSend, context);

      case MsgType.executeContract:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizationManager.of(context).translate(
                LanguageKey.transactionHistoryPageSetRecovery,
              ),
              style: AppTypoGraPhy.heading02.copyWith(
                color: appTheme.contentColorBlack,
              ),
            ),
            const SizedBox(
              height: BoxSize.boxSize06,
            ),
            SvgPicture.asset(
              AssetIconPath.historySetRecoveryLogoCircle,
            ),
            const SizedBox(
              height: BoxSize.boxSize04,
            ),
            _buildForm(
              top: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.transactionHistoryPageTo,
                        ),
                        style: AppTypoGraPhy.bodyMedium02.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize04,
                  ),
                  AccountWidget(
                    appTheme: appTheme,
                    address: address,
                    accountName: accountName,
                  ),
                ],
              ),
              bottom: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInformation(
                    LanguageKey.transactionHistoryPageTransactionFee,
                    '${pyxisTransaction.fee.formatAura} ${AppLocalizationManager.of(context).translate(
                      LanguageKey.globalPyxisAura,
                    )}',
                  ),
                  _buildInformation(
                    LanguageKey.transactionHistoryPageTransactionHash,
                    pyxisTransaction.txHash.addressView,
                  ),
                  _buildInformation(
                    LanguageKey.transactionHistoryPageTransactionTime,
                    AppDateTime.formatDateHHMMDMMMYYY(
                      pyxisTransaction.timeStamp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case MsgType.recover:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizationManager.of(context).translate(
                LanguageKey.transactionHistoryPageRecovery,
              ),
              style: AppTypoGraPhy.heading02.copyWith(
                color: appTheme.contentColorBlack,
              ),
            ),
            const SizedBox(
              height: BoxSize.boxSize06,
            ),
            SvgPicture.asset(
              AssetIconPath.historyRecoveryLogoCircle,
            ),
            const SizedBox(
              height: BoxSize.boxSize04,
            ),
            _buildForm(
              top: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.transactionHistoryPageTo,
                        ),
                        style: AppTypoGraPhy.bodyMedium02.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize04,
                  ),
                  AccountWidget(
                    appTheme: appTheme,
                    address: address,
                    accountName: accountName,
                  ),
                ],
              ),
              bottom: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInformation(
                    LanguageKey.transactionHistoryPageTransactionFee,
                    '${pyxisTransaction.fee.formatAura} ${AppLocalizationManager.of(context).translate(
                      LanguageKey.globalPyxisAura,
                    )}',
                  ),
                  _buildInformation(
                    LanguageKey.transactionHistoryPageTransactionHash,
                    pyxisTransaction.txHash.addressView,
                  ),
                  _buildInformation(
                    LanguageKey.transactionHistoryPageTransactionTime,
                    AppDateTime.formatDateHHMMDMMMYYY(
                      pyxisTransaction.timeStamp,
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

  Widget _buildReceiveWidget(MsgSend msgSend, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizationManager.of(context).translate(
            LanguageKey.transactionHistoryPageReceive,
          ),
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        SvgPicture.asset(
          AssetIconPath.historyReceiveLogoCircle,
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              '${msgSend.amount[0].amount.formatAura} ${localization.translate(
                LanguageKey.globalPyxisAura,
              )}',
              style: AppTypoGraPhy.heading03.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        _buildForm(
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLocalizationProvider(
                builder: (localization, _) {
                  return Text(
                    localization.translate(
                      LanguageKey.transactionHistoryPageTo,
                    ),
                    style: AppTypoGraPhy.bodyMedium02.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: BoxSize.boxSize04,
              ),
              AccountWidget(
                appTheme: appTheme,
                address: address,
                accountName: accountName,
              ),
            ],
          ),
          bottom: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInformation(
                LanguageKey.transactionHistoryPageFrom,
                msgSend.fromAddress.addressView,
              ),
              _buildInformation(
                LanguageKey.transactionHistoryPageTransactionHash,
                pyxisTransaction.txHash.addressView,
              ),
              _buildInformation(
                LanguageKey.transactionHistoryPageTransactionTime,
                AppDateTime.formatDateHHMMDMMMYYY(
                  pyxisTransaction.timeStamp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSendWidget(MsgSend msgSend, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizationManager.of(context).translate(
            LanguageKey.transactionHistoryPageSend,
          ),
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        SvgPicture.asset(
          AssetIconPath.historySendLogoCircle,
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              '${msgSend.amount[0].amount.formatAura} ${localization.translate(
                LanguageKey.globalPyxisAura,
              )}',
              style: AppTypoGraPhy.heading03.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        _buildForm(
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppLocalizationProvider(
                builder: (localization, _) {
                  return Text(
                    localization.translate(
                      LanguageKey.transactionHistoryPageFrom,
                    ),
                    style: AppTypoGraPhy.bodyMedium02.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: BoxSize.boxSize04,
              ),
              AccountWidget(
                appTheme: appTheme,
                address: address,
                accountName: accountName,
              ),
            ],
          ),
          bottom: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInformation(
                LanguageKey.transactionHistoryPageTo,
                msgSend.toAddress.addressView,
              ),
              _buildInformation(
                LanguageKey.transactionHistoryPageTransactionHash,
                pyxisTransaction.txHash.addressView,
              ),
              _buildInformation(
                LanguageKey.transactionHistoryPageTransactionFee,
                '${pyxisTransaction.fee.formatAura} ${AppLocalizationManager.of(context).translate(
                  LanguageKey.globalPyxisAura,
                )}',
              ),
              _buildInformation(
                LanguageKey.transactionHistoryPageTransactionTime,
                AppDateTime.formatDateHHMMDMMMYYY(
                  pyxisTransaction.timeStamp,
                ),
              ),
              _buildStatus(
                LanguageKey.transactionHistoryPageTransactionStatus,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm({
    required Widget top,
    required Widget bottom,
  }) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing05,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: BoxSize.boxSize05,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayLight,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          top,
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          const HoLiZonTalDividerWidget(),
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          bottom,
        ],
      ),
    );
  }

  Widget _buildInformation(String titleKey, String value) {
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

  Widget _buildStatus(String titleKey) {
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
          AppLocalizationProvider(builder: (localization, _) {
            return Text(
              localization.translate(
                pyxisTransaction.isSuccess
                    ? LanguageKey.transactionHistoryPageTransactionStatusSuccess
                    : LanguageKey.transactionHistoryPageTransactionStatusFail,
              ),
              style: AppTypoGraPhy.body03.copyWith(
                color: pyxisTransaction.isSuccess
                    ? appTheme.contentColorSuccess
                    : appTheme.contentColorDanger,
              ),
            );
          }),
        ],
      ),
    );
  }
}
