import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method_confirmation/recovery_method_confirmation_screen_selector.dart';
import 'recovery_account_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

class RecoveryBottomFormWidget extends StatelessWidget {
  final VoidCallback onEditFee;
  final VoidCallback onConfirm;
  final AppTheme appTheme;
  final String address;
  final String accountName;

  const RecoveryBottomFormWidget({
    required this.appTheme,
    required this.onEditFee,
    required this.address,
    required this.accountName,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecoveryAccountFormWidget(
          appTheme: appTheme,
          address: address,
          accountName: accountName,
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        const DividerSeparator(),
        Padding(
          padding: const EdgeInsets.only(
            top: Spacing.spacing04,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppLocalizationProvider(
                builder: (localization, _) {
                  return Text(
                    localization.translate(
                      LanguageKey
                          .recoveryMethodConfirmationScreenTransactionFee,
                    ),
                    style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  );
                },
              ),
              Row(
                children: [
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return RecoveryMethodConfirmationScreenFeeSelector(
                        builder: (fee) {
                          return Text(
                            '${fee.formatAura} ${localization.translate(
                              LanguageKey.globalPyxisAura,
                            )}',
                            style: AppTypoGraPhy.body03.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          );
                        },
                      );
                    },
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
              ),
            ],
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return PrimaryAppButton(
              text: localization.translate(
                LanguageKey.recoveryMethodConfirmationScreenButtonConfirmTitle,
              ),
              onPress: onConfirm,
            );
          },
        ),
      ],
    );
  }
}
