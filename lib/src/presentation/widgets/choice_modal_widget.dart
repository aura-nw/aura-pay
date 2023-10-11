import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class ChoiceModalWidget<T> extends StatefulWidget {
  final String title;
  final List<T> data;
  final List<T> selectedData;
  final VoidCallback? onClose;
  final Widget Function(T) builder;
  final ChoiceModalType modalType;
  final AppTheme appTheme;

  const ChoiceModalWidget({
    required this.data,
    required this.title,
    this.onClose,
    required this.builder,
    this.modalType = ChoiceModalType.single,
    required this.selectedData,
    required this.appTheme,
    super.key,
  });

  @override
  State<ChoiceModalWidget<T>> createState() => _ChoiceModalWidgetState<T>();
}

class _ChoiceModalWidgetState<T> extends State<ChoiceModalWidget<T>> {
  final List<T> _selectedOptions = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _selectedOptions.addAll(widget.selectedData);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing07,
        vertical: Spacing.spacing08,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: AppTypoGraPhy.heading02.copyWith(),
                ),
              ),
              const SizedBox(
                width: BoxSize.boxSize03,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (widget.onClose == null) {
                    AppNavigator.pop(_selectedOptions);
                  } else {}
                },
                child: Container(
                  padding: const EdgeInsets.all(
                    Spacing.spacing02,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.appTheme.surfaceColorGrayDefault,
                  ),
                  child: SvgPicture.asset(
                    AssetIconPath.commonClose,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: BoxSize.boxSize07,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                final T item = widget.data[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.spacing04,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      _onItemTap(item);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _selectBoxBuilder(item),
                        const SizedBox(
                          width: BoxSize.boxSize04,
                        ),
                        Expanded(
                          child: widget.builder(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectBoxBuilder(T item) {
    final bool isSelected = _selectedOptions.contains(item);

    switch (widget.modalType) {
      case ChoiceModalType.single:
        return isSelected
            ? SvgPicture.asset(
                AssetIconPath.commonRadioActive,
              )
            : SvgPicture.asset(
                AssetIconPath.commonRadioUnCheck,
              );
      case ChoiceModalType.multi:
        return const SizedBox();
    }
  }

  void _onItemTap(T item) {
    switch (widget.modalType) {
      case ChoiceModalType.single:
        AppNavigator.pop([
          item,
        ]);
        break;
      case ChoiceModalType.multi:
        if (_selectedOptions.contains(item)) {
          _selectedOptions.remove(item);
        } else {
          _selectedOptions.add(item);
        }
        setState(() {});
        break;
    }
  }
}
