import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

final class HistoryTabBarWidget extends StatefulWidget {
  final AppTheme appTheme;
  final int selectedIndex;
  final void Function(int) onChange;

  const HistoryTabBarWidget({
    required this.appTheme,
    this.selectedIndex = 0,
    required this.onChange,
    super.key,
  });

  @override
  State<HistoryTabBarWidget> createState() => _HistoryTabBarWidgetState();
}

class _HistoryTabBarWidgetState extends State<HistoryTabBarWidget> {
  final List<String> _titleKey = [
    LanguageKey.transactionHistoryPageAll,
    LanguageKey.transactionHistoryPageSend,
    LanguageKey.transactionHistoryPageReceive,
    LanguageKey.transactionHistoryPageStake,
  ];

  int selectedTab = 0;

  @override
  void initState() {
    selectedTab = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: List.generate(
              _titleKey.length,
              (index) {
                final String key = _titleKey[index];
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if(index == selectedTab) return;

                      widget.onChange(index);

                      setState(() {
                        selectedTab = index;
                      });
                    },
                    child: _HistoryTabBarItemWidget(
                      titleKey: key,
                      appTheme: widget.appTheme,
                      isSelected: selectedTab == index,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize02,
        ),
        SvgPicture.asset(
          AssetIconPath.historyMore,
        ),
      ],
    );
  }
}

final class _HistoryTabBarItemWidget extends StatelessWidget {
  final String titleKey;
  final bool isSelected;
  final AppTheme appTheme;

  const _HistoryTabBarItemWidget({
    required this.titleKey,
    this.isSelected = false,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing04,
        vertical: Spacing.spacing02,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadiusRound,
        ),
        color: isSelected ? appTheme.surfaceColorBrand : null,
      ),
      alignment: Alignment.center,
      child: AppLocalizationProvider(
        builder: (localization, _) {
          return Text(
            localization.translate(
              localization.translate(
                titleKey,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypoGraPhy.bodyMedium02.copyWith(
              color: isSelected
                  ? appTheme.contentColorWhite
                  : appTheme.contentColor500,
            ),
          );
        },
      ),
    );
  }
}
