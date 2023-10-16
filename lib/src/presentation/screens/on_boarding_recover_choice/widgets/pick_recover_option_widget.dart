import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

final class _PickRecoverOptionItemWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  final String content;
  final String iconPath;
  final AppTheme appTheme;
  final VoidCallback onTap;

  const _PickRecoverOptionItemWidget({
    required this.content,
    required this.title,
    this.isSelected = false,
    required this.iconPath,
    required this.appTheme,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(
          Spacing.spacing04,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius04,
          ),
          color: isSelected ? appTheme.surfaceColorBrandLight : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize02,
                  ),
                  Text(
                    content,
                    style: AppTypoGraPhy.body02.copyWith(
                      color: appTheme.contentColor500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            isSelected
                ? SvgPicture.asset(
                    AssetIconPath.commonRadioCheck,
                  )
                : SvgPicture.asset(
                    AssetIconPath.commonRadioUnCheck,
                  ),
          ],
        ),
      ),
    );
  }
}

class PickRecoverOptionWidget extends StatefulWidget {
  final AppTheme appTheme;
  final void Function(RecoverOptionType) onSelect;

  const PickRecoverOptionWidget({
    required this.appTheme,
    required this.onSelect,
    super.key,
  });

  @override
  State<PickRecoverOptionWidget> createState() =>
      _PickRecoverOptionWidgetState();
}

class _PickRecoverOptionWidgetState extends State<PickRecoverOptionWidget> {
  ///Default type
  RecoverOptionType type = RecoverOptionType.google;

  @override
  Widget build(BuildContext context) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Column(
          children: [
            _PickRecoverOptionItemWidget(
              content: localization.translate(
                LanguageKey.onBoardingRecoverChoiceScreenGoogleOptionContent,
              ),
              title: localization.translate(
                LanguageKey.onBoardingRecoverChoiceScreenGoogleOptionTitle,
              ),
              iconPath: AssetIconPath.onBoardingRecoverChoiceGoogle,
              appTheme: widget.appTheme,
              isSelected: type == RecoverOptionType.google,
              onTap: () {
                widget.onSelect(
                  RecoverOptionType.google,
                );
                setState(() {
                  type = RecoverOptionType.google;
                });
              },
            ),
            const SizedBox(
              height: BoxSize.boxSize02,
            ),
            _PickRecoverOptionItemWidget(
              content: localization.translate(
                LanguageKey.onBoardingRecoverChoiceScreenBackupOptionContent,
              ),
              title: localization.translate(
                LanguageKey.onBoardingRecoverChoiceScreenBackupOptionTitle,
              ),
              isSelected: type == RecoverOptionType.backupAddress,
              iconPath: AssetIconPath.onBoardingRecoverChoiceBackupAddress,
              appTheme: widget.appTheme,
              onTap: () {
                widget.onSelect(
                  RecoverOptionType.backupAddress,
                );
                setState(() {
                  type = RecoverOptionType.backupAddress;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
