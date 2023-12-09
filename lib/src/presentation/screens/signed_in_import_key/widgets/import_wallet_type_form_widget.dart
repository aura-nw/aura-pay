import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_base.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';

class ImportWalletTypeWidget extends AppBottomSheetBase {
  final ImportWalletType selected;
  final List<MapEntry<ImportWalletType, List<String>>> data;

  const ImportWalletTypeWidget({
    this.selected = ImportWalletType.privateKey,
    required this.data,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ImportWalletTypeWidgetState();
}

class _ImportWalletTypeWidgetState
    extends AppBottomSheetBaseState<ImportWalletTypeWidget> {
  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Text(
          localization.translate(
            LanguageKey.onBoardingImportKeyScreenSelectType,
          ),
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        );
      },
    );
  }

  @override
  Widget bottomBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }

  @override
  Widget contentBuilder(BuildContext context, AppTheme appTheme) {
    return Column(
      children: [
        const SizedBox(
          height: BoxSize.boxSize08,
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.data.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final MapEntry<ImportWalletType, List<String>> item =
                widget.data[index];
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.value[0],
                            style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize03,
                          ),
                          Text(
                            item.value[1],
                            style: AppTypoGraPhy.body02.copyWith(
                              color: appTheme.contentColor500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

  @override
  Widget subTitleBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }

  Widget _selectBoxBuilder(MapEntry<ImportWalletType, List<String>> item) {
    final bool isSelected = item.key == widget.selected;

    return isSelected
        ? SvgPicture.asset(
            AssetIconPath.commonRadioActive,
          )
        : SvgPicture.asset(
            AssetIconPath.commonRadioUnCheck,
          );
  }

  void _onItemTap(MapEntry<ImportWalletType, List<String>> item) {
    AppNavigator.pop([
      item,
    ]);
  }
}

class ImportWalletTypeSelectWidget extends StatefulWidget {
  final List<MapEntry<ImportWalletType, List<String>>> data;
  final List<MapEntry<ImportWalletType, List<String>>>? selectedData;
  final void Function(List<MapEntry<ImportWalletType, List<String>>>)? onChange;

  const ImportWalletTypeSelectWidget({
    required this.data,
    this.selectedData,
    super.key,
    this.onChange,
  });

  @override
  State<ImportWalletTypeSelectWidget> createState() =>
      _ImportWalletTypeSelectWidgetState();
}

class _ImportWalletTypeSelectWidgetState
    extends State<ImportWalletTypeSelectWidget> {
  final List<MapEntry<ImportWalletType, List<String>>> _selectedOption =
      List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _selectedOption.addAll(widget.selectedData ?? []);
  }

  @override
  void didUpdateWidget(covariant ImportWalletTypeSelectWidget oldWidget) {
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
            Column(
              children: [
                buildLabel(appTheme),
                const SizedBox(
                  height: BoxSize.boxSize03,
                ),
              ],
            ),
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
                    child: _selectedOption.isEmpty
                        ? const SizedBox.shrink()
                        : Text(
                            _selectedOption[0].value[0],
                            style: AppTypoGraPhy.body03.copyWith(
                              color: appTheme.contentColorUnKnow,
                            ),
                          ),
                  ),
                  const SizedBox(
                    width: BoxSize.boxSize05,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _showChoiceOption,
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

  Widget buildLabel(AppTheme theme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: localization.translate(
                  LanguageKey.onBoardingImportKeyScreenSelectType,
                ),
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
      },
    );
  }

  void _showChoiceOption() async {
    final selectData = await AppBottomSheetLayout.showFullScreenDialog(
      context,
      child: ImportWalletTypeWidget(
        data: widget.data,
        selected: _selectedOption.isEmpty
            ? ImportWalletType.privateKey
            : _selectedOption.first.key,
      ),
    );

    if (selectData == null) return;

    setState(() {});

    _selectedOption.clear();

    _selectedOption.addAll(
      selectData,
    );

    widget.onChange?.call(_selectedOption);
  }
}
