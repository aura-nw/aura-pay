import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

abstract class AppBottomSheetBase extends StatefulWidget {
  final VoidCallback? onClose;

  const AppBottomSheetBase({
    super.key,
    this.onClose,
  });

  @override
  State<StatefulWidget> createState() =>
      AppBottomSheetBaseState<AppBottomSheetBase>();
}

class AppBottomSheetBaseState<R extends AppBottomSheetBase> extends State<R> {
  Widget titleBuilder(
    BuildContext context,
    AppTheme appTheme,
  ) {
    throw UnimplementedError();
  }

  Widget subTitleBuilder(
    BuildContext context,
    AppTheme appTheme,
  ) {
    throw UnimplementedError();
  }

  Widget contentBuilder(
    BuildContext context,
    AppTheme appTheme,
  ) {
    throw UnimplementedError();
  }

  Widget bottomBuilder(
    BuildContext context,
    AppTheme appTheme,
  ) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing07,
            vertical: Spacing.spacing06,
          ),
          decoration: BoxDecoration(
            color: appTheme.bodyColorBackground,
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadius06,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: titleBuilder(
                        context,
                        appTheme,
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (widget.onClose != null) {
                        widget.onClose!();
                      } else {
                        AppNavigator.pop();
                      }
                    },
                    child: SvgPicture.asset(
                      AssetIconPath.commonCloseBottomSheet,
                    ),
                  ),
                ],
              ),
              subTitleBuilder(
                context,
                appTheme,
              ),
              contentBuilder(
                context,
                appTheme,
              ),
              bottomBuilder(
                context,
                appTheme,
              ),
            ],
          ),
        );
      },
    );
  }
}
