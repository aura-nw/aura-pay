import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_base.dart';

class ForgotPasscodeFormWidget extends AppBottomSheetBase {
  const ForgotPasscodeFormWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasscodeFormWidgetState();
}

class _ForgotPasscodeFormWidgetState
    extends AppBottomSheetBaseState<ForgotPasscodeFormWidget> {
  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Text(
          localization.translate(
            LanguageKey.onBoardingReLoginScreenDialogForgetPasswordTitle,
          ),
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        );
      },
    );
  }

  @override
  Widget contentBuilder(BuildContext context, AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: BoxSize.boxSize08,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Align(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingReLoginScreenDialogForgetPasswordContentRegionOne,
                      ),
                      style: AppTypoGraPhy.body02.copyWith(
                        color: appTheme.contentColor500,
                      ),
                    ),
                    TextSpan(
                      text: ' ${localization.translate(
                        LanguageKey
                            .onBoardingReLoginScreenDialogForgetPasswordContentRegionTwo,
                      )}',
                      style: AppTypoGraPhy.bodyMedium02.copyWith(
                        color: appTheme.contentColor700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget bottomBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }

  @override
  Widget subTitleBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }
}
