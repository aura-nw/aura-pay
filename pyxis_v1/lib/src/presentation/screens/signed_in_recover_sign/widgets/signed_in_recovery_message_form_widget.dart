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
import 'package:pyxis_mobile/src/presentation/screens/signed_in_recover_sign/signed_in_recover_sign_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_box_widget.dart';

class SignedInRecoveryMessageWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String newAddress;
  final String address;
  final VoidCallback onChangeViewData;

  const SignedInRecoveryMessageWidget({
    required this.appTheme,
    required this.newAddress,
    required this.address,
    required this.onChangeViewData,
    super.key,
  });

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
                    LanguageKey.signedInRecoverSignScreenMessages,
                  ),
                  style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                );
              },
            ),
            SignedInRecoverSignIsShowFullMsgSelector(
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
                              LanguageKey.signedInRecoverSignScreenViewData,
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
          child: SignedInRecoverSignIsShowFullMsgSelector(
            builder: (isShowFullMsg) {
              if (isShowFullMsg) {
                return SignedInRecoverSignMsgSelector(
                  builder: (message) {
                    return ScrollBarWidget(
                      appTheme: appTheme,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: BoxSize.boxSize15,
                          minHeight: BoxSize.boxSize13,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            prettyJson(
                              AuraSmartAccountHelper.writeMessageToJson(message),
                            ),
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
                                    .signedInRecoverSignScreenUpdateKey,
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
                                    .signedInRecoverSignScreenUpdateKeyContent,
                                {
                                  'address': address.addressView,
                                  'newAddress': newAddress,
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
