import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

final class _AccountTypeWidget extends StatelessWidget {
  final String type;
  final bool isSelected;
  final AppTheme appTheme;
  final VoidCallback onTap;

  const _AccountTypeWidget({
    required this.type,
    super.key,
    this.isSelected = false,
    required this.appTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing05,
              vertical: Spacing.spacing03,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius03,
              ),
              border: Border.all(
                  width: BorderSize.border01,
                  color: isSelected
                      ? appTheme.borderColorBrand
                      : appTheme.borderColorGrayDefault),
              color: isSelected
                  ? appTheme.surfaceColorBrandLight
                  : appTheme.surfaceColorWhite,
            ),
            alignment: Alignment.center,
            child: Text(
              type,
              style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                color: appTheme.contentColorBlack,
              ),
            ),
          ),
          if (isSelected)
            Positioned(
              top: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(BorderRadiusSize.borderRadius03),
                ),
                child: SvgPicture.asset(
                  AssetIconPath.onBoardingImportKeyCheck,
                ),
              ),
            )
          else
            const SizedBox(),
        ],
      ),
    );
  }
}

final class AccountTypeChoiceWidget extends StatefulWidget {
  final void Function(PyxisWalletType) onSelected;
  final AppTheme appTheme;
  final PyxisWalletType defaultType;

  const AccountTypeChoiceWidget({
    required this.onSelected,
    required this.appTheme,
    this.defaultType = PyxisWalletType.smartAccount,
    super.key,
  });

  @override
  State<AccountTypeChoiceWidget> createState() =>
      _AccountTypeChoiceWidgetState();
}

class _AccountTypeChoiceWidgetState extends State<AccountTypeChoiceWidget> {
  ///Default account type
  late PyxisWalletType _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.defaultType;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AccountTypeChoiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedIndex = widget.defaultType;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return _AccountTypeWidget(
                type: localization.translate(
                    LanguageKey.onBoardingImportKeyScreenSmartAccountType),
                appTheme: widget.appTheme,
                onTap: () {
                  _onSelectedType(PyxisWalletType.smartAccount);
                },
                isSelected: _selectedIndex == PyxisWalletType.smartAccount,
              );
            },
          ),
          const SizedBox(
            width: BoxSize.boxSize05,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return _AccountTypeWidget(
                type: localization.translate(
                    LanguageKey.onBoardingImportKeyScreenNormalAccountType),
                appTheme: widget.appTheme,
                onTap: () {
                  _onSelectedType(PyxisWalletType.normalWallet);
                },
                isSelected: _selectedIndex == PyxisWalletType.normalWallet,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSelectedType(PyxisWalletType type) {
    if (_selectedIndex == type) return;

    _selectedIndex = type;

    setState(() {});

    widget.onSelected(_selectedIndex);
  }
}
