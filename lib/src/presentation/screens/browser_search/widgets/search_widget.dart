import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final AppTheme appTheme;
  final void Function(String) onChanged;
  final void Function() onClear;

  const SearchWidget({
    required this.controller,
    required this.appTheme,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayLight,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadiusRound,
        ),
        border: Border.all(
          color: appTheme.borderColorGrayLight,
        ),
      ),
      child: AppLocalizationProvider(builder: (localization, _) {
        return TextInputOnlyTextFieldWidget(
          enableClear: true,
          controller: controller,
          onChanged: (value, _) {
            onChanged(value);
          },
          onClear: onClear,
          hintText: localization.translate(
            LanguageKey.inAppBrowserSearchScreenHint,
          ),
        );
      }),
    );
  }
}
