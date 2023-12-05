import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class TextInputRecipientWidget extends TextInputWidgetBase {
  final VoidCallback onClear;
  final VoidCallback onPaste;
  final VoidCallback onQrTap;

  const TextInputRecipientWidget({
    required this.onClear,
    required this.onPaste,
    required this.onQrTap,
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
  });

  @override
  State<StatefulWidget> createState() => TextInputRecipientState();
}

final class TextInputRecipientState
    extends TextInputWidgetBaseState<TextInputRecipientWidget> {

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return inputFormBuilder(
          context,
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onQrTap,
                child: SvgPicture.asset(
                  AssetIconPath.sendQr,
                ),
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              Expanded(
                child: buildTextInput(theme),
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onPaste,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing03,
                    vertical: Spacing.spacing02,
                  ),
                  decoration: BoxDecoration(
                    color: theme.surfaceColorBrandLight,
                    borderRadius: BorderRadius.circular(
                      BorderRadiusSize.borderRadiusRound,
                    ),
                  ),
                  child: AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.sendTransactionRecipientPaste,
                        ),
                        style: AppTypoGraPhy.bodyMedium02.copyWith(
                          color: theme.contentColorBrandDark,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              GestureDetector(
                onTap: widget.onClear,
                behavior: HitTestBehavior.opaque,
                child: SvgPicture.asset(
                  AssetIconPath.commonClose,
                ),
              ),
            ],
          ),
          theme,
        );
      },
    );
  }
}
