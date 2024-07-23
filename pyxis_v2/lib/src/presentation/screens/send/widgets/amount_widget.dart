import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_v2/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_v2/src/presentation/widgets/text_input_base/text_input_manager.dart';

class SendScreenAmountToSendWidget extends StatelessWidget {
  final AppLocalizationManager localization;
  final AppTheme appTheme;

  const SendScreenAmountToSendWidget({
    required this.appTheme,
    required this.localization,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _TextInputAmountWidget(
      appTheme: appTheme,
      localization: localization,
      hintText: '0.00',
      keyBoardType: TextInputType.number,
      constraintManager: ConstraintManager()
        ..custom(
          errorMessage: localization.translate(
            LanguageKey.sendScreenAmountInvalid,
          ),
          customValid: (value) {
            return false;
          },
        ),
    );
  }
}

final class _TextInputAmountWidget extends TextInputWidgetBase {
  final AppLocalizationManager localization;

  const _TextInputAmountWidget({
    super.obscureText,
    super.autoFocus,
    super.constraintManager,
    super.scrollController,
    super.enable,
    super.inputFormatter,
    super.focusNode,
    super.controller,
    super.hintText,
    super.scrollPadding,
    super.keyBoardType,
    super.maxLength,
    super.onSubmit,
    super.maxLine,
    super.minLine,
    super.onChanged,
    super.physics,
    super.key,
    super.enableClear,
    super.onClear,
    super.boxConstraints,
    required super.appTheme,
    required this.localization,
  });

  @override
  State<StatefulWidget> createState() => _TextInputAmountWidgetState();
}

class _TextInputAmountWidgetState
    extends TextInputWidgetBaseState<_TextInputAmountWidget> {
  AppLocalizationManager get localization => widget.localization;

  @override
  Widget? buildLabel(AppTheme theme) {
    return Text(
      localization.translate(
        LanguageKey.sendScreenAmount,
      ),
      style: AppTypoGraPhy.textSmSemiBold.copyWith(
        color: theme.textPrimary,
      ),
    );
  }

  @override
  Widget inputFormBuilder(BuildContext context, Widget child, AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(theme) != null
            ? Column(
                children: [
                  buildLabel(theme)!,
                  const SizedBox(
                    height: BoxSize.boxSize03,
                  ),
                ],
              )
            : const SizedBox(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColorBuilder(theme),
              width: BorderSize.border01,
            ),
            color: theme.bgPrimary,
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadius03M,
            ),
            boxShadow: buildShadows(
              theme,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing04,
                  vertical: Spacing.spacing02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: child,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: const Row(
                            children: [
                               SizedBox(
                                width: BoxSize.boxSize04,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize05,
                    ),
                    Text(
                      '~${localization.translate(
                        LanguageKey.commonBalancePrefix,
                      )}0',
                      style: AppTypoGraPhy.textXsRegular.copyWith(
                        color: theme.textTertiary,
                      ),
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize05,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.spacing04,
                  horizontal: Spacing.spacing05,
                ),
                decoration: BoxDecoration(
                  color: theme.bgSecondary,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(
                      BorderRadiusSize.borderRadius03M,
                    ),
                    bottomLeft: Radius.circular(
                      BorderRadiusSize.borderRadius03M,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        localization.translate(
                          LanguageKey.sendScreenMax,
                        ),
                        style: AppTypoGraPhy.textSmSemiBold.copyWith(
                          color: theme.textBrandPrimary,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: localization.translate(
                                LanguageKey.sendScreenBalance,
                              ),
                              style: AppTypoGraPhy.textXsRegular.copyWith(
                                color: theme.textSecondary,
                              )),
                          TextSpan(
                              text: ' 120',
                              style: AppTypoGraPhy.textXsSemiBold.copyWith(
                                color: theme.textPrimary,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        errorMessage.isNotNullOrEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: BoxSize.boxSize03,
                  ),
                  Text(
                    errorMessage!,
                    style: AppTypoGraPhy.textSmRegular.copyWith(
                      color: theme.textErrorPrimary,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
