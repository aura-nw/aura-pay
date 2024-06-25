import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/pyxis_wallet_core/pyxis_wallet_helper.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_import_normal_wallet_key/on_boarding_import_normal_wallet_key_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

class ImportWalletPrivateKeyWidget extends StatelessWidget {
  final AppLocalizationManager localization;
  final AppTheme appTheme;
  final GlobalKey<TextInputNormalSuffixState> inPutPrivateKey;
  final void Function(String, bool) onChanged;
  final VoidCallback onShowPrivateKey;
  final VoidCallback onPaste;

  const ImportWalletPrivateKeyWidget({
    required this.localization,
    required this.appTheme,
    required this.inPutPrivateKey,
    required this.onChanged,
    required this.onShowPrivateKey,
    required this.onPaste,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: localization.translate(
                      LanguageKey
                          .onBoardingImportNormalWalletKeyScreenPrivateKey,
                    ),
                    style: AppTypoGraPhy.utilityLabelSm.copyWith(
                      color: appTheme.contentColor700,
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: AppTypoGraPhy.utilityLabelSm.copyWith(
                      color: appTheme.contentColorDanger,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onPaste,
              behavior: HitTestBehavior.opaque,
              child: TextWithIconWidget(
                titlePath: localization.translate(
                  LanguageKey.onBoardingImportNormalWalletKeyScreenPaste,
                ),
                svgIconPath: AssetIconPath.commonPaste,
                appTheme: appTheme,
                style: AppTypoGraPhy.bodyMedium02.copyWith(
                  color: appTheme.contentColorBrand,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize01,
        ),
        OnBoardingImportNormalWalletKeyShowPrivateKeySelector(
          builder: (showPrivateKey) {
            return TextInputNormalSuffixWidget(
              suffix: !showPrivateKey
                  ? SvgPicture.asset(
                      AssetIconPath.commonEyeHide,
                    )
                  : SvgPicture.asset(
                      AssetIconPath.commonEyeActive,
                    ),
              key: inPutPrivateKey,
              maxLine: 1,
              onChanged: onChanged,
              constraintManager: ConstraintManager(
                isStopWhenFirstFailure: true,
                isValidOnChanged: true,
              )..custom(
                  errorMessage: localization.translate(LanguageKey
                      .onBoardingImportNormalWalletKeyScreenInvalidPrivateKey),
                  customValid: (value) {
                    try {
                      return PyxisWalletHelper.checkPrivateKey(
                        value.trim(),
                      );
                    } catch (e) {
                      return false;
                    }
                  },
                ),
              obscureText: !showPrivateKey,
              onSuffixTap: onShowPrivateKey,
            );
          },
        ),
      ],
    );
  }
}
