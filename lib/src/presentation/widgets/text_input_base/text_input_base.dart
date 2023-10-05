import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/border_constant.dart';
import 'package:pyxis_mobile/src/core/constants/spacing.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'text_input_manager.dart';

///region text input base
sealed class TextInputWidgetBase<T> extends StatefulWidget {
  final TextEditingController? controller;
  final ConstraintManager? constraintManager;
  final String? hintText;
  final void Function(String, bool)? onChanged;
  final void Function(String, bool)? onSubmit;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final bool enable;
  final bool autoFocus;
  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyBoardType;

  const TextInputWidgetBase({
    super.key,
    this.constraintManager,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmit,
    this.maxLength,
    this.minLine,
    this.maxLine,
    this.enable = true,
    this.autoFocus = false,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.symmetric(),
    this.scrollController,
    this.physics,
    this.inputFormatter,
    this.keyBoardType,
  });

  @override
  State<StatefulWidget> createState() {
    return _TextInputWidgetBaseState<TextInputWidgetBase<T>>();
  }
}

class _TextInputWidgetBaseState<T extends TextInputWidgetBase>
    extends State<T> {
  late TextEditingController _controller;

  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget? buildLabel(AppTheme theme) {
    return null;
  }

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
                    height: Spacing.spacingUnit12,
                  ),
                ],
              )
            : const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacingUnit12,
            vertical: Spacing.spacingUnit8,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.borderColorGray,
                width: BorderConstant.border01,
              ),
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildTextInput(AppTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          style: AppTypoGraPhy.bodyMedium01,
          enabled: widget.enable,
          autofocus: widget.autoFocus,
          maxLines: widget.maxLine,
          maxLength: widget.maxLength,
          minLines: widget.minLine,
          onSubmitted: (value) {
            if (widget.onSubmit != null) {
              widget.onSubmit!(value, errorMessage.isEmptyOrNull);
            }
          },
          focusNode: widget.focusNode,
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
            hintStyle: AppTypoGraPhy.body03,
          ),
        ),
        errorMessage.isNotNullOrEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Spacing.spacingUnit8,
                  ),
                  Text(
                    errorMessage!,
                    style: AppTypoGraPhy.body01,
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return inputFormBuilder(
          context,
          _buildTextInput(theme),
          theme,
        );
      },
    );
  }

  String value() => _controller.text;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != null &&
        oldWidget.controller?.text != _controller.text) {
      _controller = widget.controller!;
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

final class TextInputNormalWidget extends TextInputWidgetBase {
  final String? label;
  final bool isRequired;

  const TextInputNormalWidget({
    this.label,
    this.isRequired = false,
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
}

final class TextInputNormalState
    extends _TextInputWidgetBaseState<TextInputNormalWidget> {
  @override
  Widget? buildLabel(AppTheme theme) {
    if (widget.label.isEmptyOrNull) {
      return null;
    }

    if (widget.isRequired) {
      return Text(
        '${widget.label!} *',
        style: AppTypoGraPhy.utilityLabelSm.copyWith(
          color: theme.contentColor700,
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
