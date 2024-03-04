import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/json_formatter.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method_confirmation/recovery_method_confirmation_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_box_widget.dart';

class RecoveryMessageWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String recoverData;
  final String address;
  final VoidCallback onChangeViewData;

  const RecoveryMessageWidget({
    required this.appTheme,
    required this.recoverData,
    required this.address,
    required this.onChangeViewData,
    super.key,
  });

  String _parserMsg(List<GeneratedMessage> messages) {
    final List<String> listObj = messages.map(
      (e) {
        final Map<String, dynamic> json =
            AuraSmartAccountHelper.writeMessageToJson(e);

        return prettyJson(json);
      },
    ).toList();

    return listObj.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    LanguageKey.recoveryMethodConfirmationScreenMessages,
                  ),
                  style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                );
              },
            ),
            RecoveryMethodConfirmationScreenIsShowFullMsgSelector(
              builder: (isShowFullMessage) {
                return GestureDetector(
                  onTap: onChangeViewData,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      isShowFullMessage
                          ? SvgPicture.asset(
                              AssetIconPath.commonViewRawActive,
                            )
                          : SvgPicture.asset(
                              AssetIconPath.commonViewRaw,
                            ),
                      const SizedBox(
                        width: BoxSize.boxSize03,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey
                                  .recoveryMethodConfirmationScreenViewData,
                            ),
                            style: AppTypoGraPhy.bodyMedium02.copyWith(
                              color: isShowFullMessage
                                  ? appTheme.contentColorBrand
                                  : appTheme.contentColor700,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        TransactionBoxWidget(
          appTheme: appTheme,
          child: RecoveryMethodConfirmationScreenIsShowFullMsgSelector(
            builder: (isShowFullMsg) {
              if (isShowFullMsg) {
                return RecoveryMethodConfirmationScreenMessagesSelector(
                  builder: (messages) {
                    return ScrollBarWidget(
                      appTheme: appTheme,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: BoxSize.boxSize15,
                          minHeight: BoxSize.boxSize13,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            _parserMsg(messages),
                            style: AppTypoGraPhy.body02.copyWith(
                              color: appTheme.contentColor500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Row(
                children: [
                  SvgPicture.asset(
                    AssetIconPath.commonSignMessage,
                  ),
                  const SizedBox(
                    width: BoxSize.boxSize04,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translate(
                                LanguageKey
                                    .recoveryMethodConfirmationScreenChangeRecovery,
                              ),
                              style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                                color: appTheme.contentColorBlack,
                              ),
                            );
                          },
                        ),
                        const SizedBox(),
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translateWithParam(
                                LanguageKey
                                    .recoveryMethodConfirmationScreenMessage,
                                {
                                  'account': recoverData,
                                  'address': address.addressView,
                                },
                              ),
                              style: AppTypoGraPhy.bodyMedium02.copyWith(
                                color: appTheme.contentColor500,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
