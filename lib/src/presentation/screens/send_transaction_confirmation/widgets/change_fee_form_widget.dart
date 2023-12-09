import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/slider_base_widget.dart';

class ChangeFeeFormWidget extends AppBottomSheetBase {
  final double currentValue;
  final double max;
  final double min;

  const ChangeFeeFormWidget({
    super.key,
    super.onClose,
    required this.max,
    required this.min,
    required this.currentValue,
  });

  @override
  State<StatefulWidget> createState() => _ChangeFeeFormWidgetState();
}

class _ChangeFeeFormWidgetState
    extends AppBottomSheetBaseState<ChangeFeeFormWidget> {
  double _value = 0.0;

  @override
  void initState() {
    _value = widget.currentValue;
    super.initState();
  }

  @override
  Widget bottomBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return PrimaryAppButton(
          text: localization.translate(
            LanguageKey
                .sendTransactionConfirmationScreenChangeFeeEstimateApplyButtonTitle,
          ),
          onPress: () {
            AppNavigator.pop(_value);
          },
        );
      },
    );
  }

  @override
  Widget contentBuilder(BuildContext context, AppTheme appTheme) {
    return Column(
      children: [
        CustomSingleSlider(
          max: widget.max,
          min: widget.min,
          onChange: (value) {
            String valueString = (value as double).toStringAsFixed(6);
            setState(() {
              _value = double.parse(valueString);
            });
          },
          current: widget.currentValue,
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        AppLocalizationProvider(builder: (localization, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.translate(
                  LanguageKey
                      .sendTransactionConfirmationScreenChangeFeeEstimateSlower,
                ),
                style: AppTypoGraPhy.utilityHelperSm.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              ),
              Text(
                localization.translate(
                  LanguageKey
                      .sendTransactionConfirmationScreenChangeFeeEstimateFaster,
                ),
                style: AppTypoGraPhy.utilityHelperSm.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              ),
            ],
          );
        }),
        const SizedBox(
          height: BoxSize.boxSize08,
        ),
      ],
    );
  }

  @override
  Widget subTitleBuilder(BuildContext context, AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: BoxSize.boxSize02,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: localization.translate(
                    LanguageKey
                        .sendTransactionConfirmationScreenChangeFeeEstimate,
                  ),
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
                TextSpan(
                    text: ' ${_value.toString().toAura} ${localization.translate(
                      LanguageKey.globalPyxisAura,
                    )}',
                    style: AppTypoGraPhy.bodyMedium02.copyWith(
                      color: appTheme.contentColorBlack,
                    )),
              ]),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
      ],
    );
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Text(
          localization.translate(
            LanguageKey.sendTransactionConfirmationScreenChangeFeeTitle,
          ),
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        );
      },
    );
  }
}
