import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final AppTheme appTheme;

  const SearchWidget({
    required this.controller,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing05,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayDefault,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadiusRound,
        ),
      ),
      child: TextInputOnlyTextFieldWidget(
        enableClear: true,
        controller: controller,
      ),
    );
  }
}
