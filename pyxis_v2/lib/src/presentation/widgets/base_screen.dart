import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_v2/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';

mixin StatelessBaseScreen on StatelessWidget {
  Widget buildSpace(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing05,
          horizontal: Spacing.spacing07,
        ),
        child: child(context),
      ),
    );
  }

  Widget child(BuildContext context);

  Widget wrapBuild(BuildContext context, Widget child);

  @override
  Widget build(BuildContext context) {
    return wrapBuild(
      context,
      buildSpace(context),
    );
  }
}

mixin StateFulBaseScreen<T extends StatefulWidget> on State<T> {
  Widget buildSpace(
    BuildContext context,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.spacing05,
          horizontal: Spacing.spacing07,
        ),
        child: child(
          context,
          appTheme,
          localization,
        ),
      ),
    );
  }

  Widget child(
    BuildContext context,
    AppTheme appTheme,
    AppLocalizationManager localization,
  );

  Widget wrapBuild(
    BuildContext context,
    Widget child,
    AppTheme appTheme,
    AppLocalizationManager localization,
  );

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(
          builder: (localization, _) {
            return wrapBuild(
              context,
              buildSpace(
                context,
                appTheme,
                localization,
              ),
              appTheme,
              localization,
            );
          },
        );
      },
    );
  }
}
