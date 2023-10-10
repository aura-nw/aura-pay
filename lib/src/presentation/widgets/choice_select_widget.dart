import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/choice_modal_widget.dart';

class ChoiceSelectWidget<T> extends StatefulWidget {
  final List<T> data;
  final List<T>? selectedData;
  final String? label;
  final bool isRequired;
  final Widget Function(List<T>) builder;
  final Widget Function(T) optionBuilder;
  final String modalTitle;
  final ChoiceModalType modalType;
  final ChoiceModalSize modalSize;
  final VoidCallback? onCloseModal;
  final void Function(List<T>)? onChange;

  const ChoiceSelectWidget({
    required this.data,
    this.selectedData,
    this.label,
    this.isRequired = false,
    super.key,
    required this.builder,
    required this.optionBuilder,
    required this.modalTitle,
    this.modalType = ChoiceModalType.single,
    this.modalSize = ChoiceModalSize.small,
    this.onCloseModal,
    this.onChange,
  });

  @override
  State<ChoiceSelectWidget<T>> createState() => _ChoiceSelectWidgetState<T>();
}

class _ChoiceSelectWidgetState<T> extends State<ChoiceSelectWidget<T>> {
  final List<T> _selectedOption = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _selectedOption.addAll(widget.selectedData ?? []);
  }

  @override
  void didUpdateWidget(covariant ChoiceSelectWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedData != oldWidget.selectedData) {
      _selectedOption.addAll(widget.selectedData ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.label != null
                ? Column(
                    children: [
                      buildLabel(appTheme)!,
                      const SizedBox(
                        height: BoxSize.boxSize03,
                      ),
                    ],
                  )
                : const SizedBox(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing0,
                vertical: Spacing.spacing02,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: appTheme.borderColorGrayDefault,
                    width: BorderSize.border01,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: widget.builder(_selectedOption),
                  ),
                  const SizedBox(
                    width: BoxSize.boxSize05,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _showChoiceOption(appTheme);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.spacing02),
                      child: SvgPicture.asset(
                        AssetIconPath.commonArrowDown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

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

  double get _buildConstraint {
    switch (widget.modalSize) {
      case ChoiceModalSize.small:
        return BoxSize.boxSize18;
      case ChoiceModalSize.medium:
        return BoxSize.boxSize18 * 2;
      case ChoiceModalSize.high:
        return BoxSize.boxSize18 * 2.7;
    }
  }

  void _showChoiceOption(AppTheme theme) async {
    final List<T>? selectData = await showModalBottomSheet<List<T>>(
      context: context,
      backgroundColor: theme.bodyColorBackground,
      constraints: BoxConstraints(
        maxHeight: _buildConstraint,
      ),
      builder: (context) {
        return ChoiceModalWidget<T>(
          data: widget.data,
          title: widget.modalTitle,
          builder: widget.optionBuilder,
          modalType: widget.modalType,
          onClose: widget.onCloseModal,
          selectedData: _selectedOption,
          appTheme: theme,
        );
      },
    );

    setState(() {});

    _selectedOption.clear();

    _selectedOption.addAll(
      selectData ?? [],
    );

    widget.onChange?.call(_selectedOption);
  }
}
