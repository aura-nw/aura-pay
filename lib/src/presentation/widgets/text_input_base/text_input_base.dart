import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'text_input_manager.dart';

///region text input base
class TextInputWidgetBase extends StatefulWidget {
  final TextEditingController? controller;
  final ConstraintManager? constraintManager;
  final String? hintText;
  final VoidCallback? onClear;
  final void Function(String, bool)? onChanged;
  final void Function(String, bool)? onSubmit;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final bool enable;
  final bool obscureText;
  final bool autoFocus;
  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyBoardType;
  final bool enableClear;
  final BoxConstraints? boxConstraints;

  const TextInputWidgetBase({
    super.key,
    this.constraintManager,
    this.onClear,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmit,
    this.maxLength,
    this.minLine,
    this.maxLine,
    this.enable = true,
    this.autoFocus = false,
    this.obscureText = false,
    this.enableClear = false,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.symmetric(),
    this.scrollController,
    this.physics,
    this.inputFormatter,
    this.keyBoardType,
    this.boxConstraints,
  });

  @override
  State<StatefulWidget> createState() {
    return TextInputWidgetBaseState<TextInputWidgetBase>();
  }
}

class TextInputWidgetBaseState<T extends TextInputWidgetBase> extends State<T> {
  late TextEditingController _controller;

  String? errorMessage;

  late FocusNode _focusNode;

  bool enableClear = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget? buildLabel(AppTheme theme) {
    return null;
  }

  ///region build input form builder
  Widget inputFormBuilder(
    BuildContext context,
    Widget child,
    AppTheme theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(theme) != null
            ? Column(
                children: [
                  buildLabel(theme)!,
                  const SizedBox(
                    height: BoxSize.boxSize01,
                  ),
                ],
              )
            : const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing0,
            vertical: Spacing.spacing01,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _borderColorBuilder(theme),
                width: BorderSize.border01,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: child,
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
                    style: AppTypoGraPhy.body02.copyWith(
                      color: theme.contentColorDanger,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  ///endregion

  ///region build text input base
  Widget buildTextInput(AppTheme theme) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: AppTypoGraPhy.body03.copyWith(
              color: theme.contentColorBlack,
            ),
            enabled: widget.enable,
            autofocus: widget.autoFocus,
            maxLines: widget.maxLine,
            maxLength: widget.maxLength,
            minLines: widget.minLine,
            obscureText: widget.obscureText,
            onSubmitted: (value) {
              if (widget.onSubmit != null) {
                widget.onSubmit!(value, errorMessage.isEmptyOrNull);
              }
            },
            focusNode: _focusNode,
            showCursor: true,
            scrollPadding: widget.scrollPadding,
            scrollController: widget.scrollController,
            scrollPhysics: widget.physics,
            inputFormatters: widget.inputFormatter,
            keyboardType: widget.keyBoardType,
            onChanged: (value) {
              if (widget.constraintManager != null) {
                if (widget.constraintManager!.isValidOnChanged) {
                  validate();
                }
              }

              widget.onChanged?.call(value, errorMessage.isEmptyOrNull);
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintStyle: AppTypoGraPhy.body03.copyWith(
                color: theme.contentColor500,
              ),
              constraints: widget.boxConstraints,

              /// This line may be fix in the future.
              counterText: '',
            ),
          ),
        ),
        if (errorMessage.isNotNullOrEmpty) ...[
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          SvgPicture.asset(
            AssetIconPath.commonInputError,
          ),
        ],
        if (enableClear && widget.enableClear) ...[
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
        ]
      ],
    );
  }

  ///endregion

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return inputFormBuilder(
          context,
          buildTextInput(theme),
          theme,
        );
      },
    );
  }

  String value() => _controller.text;

  late bool isFocus;

  Color _borderColorBuilder(AppTheme theme) {
    Color color = theme.borderColorGrayDefault;
    if (isFocus) {
      color = theme.borderColorBrand;
    }

    if (errorMessage.isEmptyOrNull) {
      if (isFocus) return color;

      color = theme.borderColorGrayDefault;
    } else {
      color = theme.borderColorDanger;
    }

    return color;
  }

  void _addFocusListener() {
    if (_focusNode.hasFocus) {
      isFocus = true;
    } else {
      isFocus = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onTextInputChange() {
    if (!widget.enableClear) return;
    if (_controller.text.trim().isEmpty) {
      enableClear = false;
    } else {
      enableClear = true;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(_onTextInputChange);

    _focusNode = widget.focusNode ?? FocusNode(canRequestFocus: true);

    isFocus = widget.autoFocus;

    _focusNode.addListener(_addFocusListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextInputChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_addFocusListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != null &&
        oldWidget.controller?.text != _controller.text) {
      _controller = widget.controller!;
      _controller.addListener(_onTextInputChange);
    }
  }

  bool validate() {
    ConstraintManager? constraintManager = widget.constraintManager;
    errorMessage = null;
    if (constraintManager != null) {
      final CheckResult result = constraintManager.checkAll(
        _controller.text,
      );
      if (!result.isSuccess) {
        errorMessage = result.message;
      } else {
        errorMessage = null;
      }
      setState(() {});
      return result.isSuccess;
    }
    setState(() {});
    return true;
  }
}

///endregion

///region text input normal
final class TextInputNormalWidget extends TextInputWidgetBase {
  final String? label;
  final bool isRequired;

  const TextInputNormalWidget({
    this.label,
    this.isRequired = false,
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
    super.boxConstraints,
    super.enableClear,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => TextInputNormalState();
}

final class TextInputNormalState
    extends TextInputWidgetBaseState<TextInputNormalWidget> {
  @override
  Widget? buildLabel(AppTheme theme) {
    if (widget.label.isEmptyOrNull) {
      return null;
    }

    if (widget.isRequired) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.label,
              style: AppTypoGraPhy.utilityLabelSm.copyWith(
                color: theme.contentColor700,
              ),
            ),
            TextSpan(
              text: ' *',
              style: AppTypoGraPhy.utilityLabelSm.copyWith(
                color: theme.contentColorDanger,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      widget.label!,
      style: AppTypoGraPhy.utilityLabelSm.copyWith(
        color: theme.contentColor700,
      ),
    );
  }
}

///endregion

///region text input suffix widget
final class TextInputNormalSuffixWidget extends TextInputWidgetBase {
  final String? label;
  final bool isRequired;
  final Widget suffix;
  final VoidCallback? onSuffixTap;

  const TextInputNormalSuffixWidget({
    this.label,
    this.isRequired = false,
    required this.suffix,
    this.onSuffixTap,
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
    super.boxConstraints,
    super.enableClear,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => TextInputNormalSuffixState();
}

final class TextInputNormalSuffixState
    extends TextInputWidgetBaseState<TextInputNormalSuffixWidget> {
  @override
  Widget? buildLabel(AppTheme theme) {
    if (widget.label.isEmptyOrNull) {
      return null;
    }

    if (widget.isRequired) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: widget.label,
              style: AppTypoGraPhy.utilityLabelSm.copyWith(
                color: theme.contentColor700,
              ),
            ),
            TextSpan(
              text: ' *',
              style: AppTypoGraPhy.utilityLabelSm.copyWith(
                color: theme.contentColorDanger,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      widget.label!,
      style: AppTypoGraPhy.utilityLabelSm.copyWith(
        color: theme.contentColor700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return inputFormBuilder(
          context,
          Row(
            children: [
              Expanded(
                child: buildTextInput(theme),
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              GestureDetector(
                onTap: widget.onSuffixTap,
                behavior: HitTestBehavior.opaque,
                child: widget.suffix,
              ),
            ],
          ),
          theme,
        );
      },
    );
  }
}

///endregion

///region text input with only text field widget
final class TextInputOnlyTextFieldWidget extends TextInputWidgetBase {
  const TextInputOnlyTextFieldWidget({
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
  });

  @override
  State<StatefulWidget> createState() => TextInputOnlyTextFieldWidgetState();
}

final class TextInputOnlyTextFieldWidgetState
    extends TextInputWidgetBaseState<TextInputOnlyTextFieldWidget> {
  @override
  Widget? buildLabel(AppTheme theme) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return buildTextInput(theme);
      },
    );
  }
}

///endregion
