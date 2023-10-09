import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

abstract interface class _AppBarBase extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final AppTheme appTheme;

  const _AppBarBase({this.onBack, required this.appTheme, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (onBack == null) {
            AppNavigator.pop();
          } else {
            onBack!.call();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing04,
          ),
          child: SvgPicture.asset(
            AssetIconPath.commonArrowBack,
            height: BoxSize.boxSize07,
            width: BoxSize.boxSize07,
          ),
        ),
      ),
      title: titleBuilder(context, appTheme),
      centerTitle: true,
      bottom: bottomBuilder(appTheme),
      actions: actionBuilders(context, appTheme),
      bottomOpacity: 0,
      backgroundColor: appTheme.bodyColorBackground,
      elevation: 0,
    );
  }

  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme);

  PreferredSizeWidget? bottomBuilder(AppTheme appTheme);

  Widget titleBuilder(BuildContext context, AppTheme appTheme);

  @override
  Size get preferredSize =>
      Size.fromHeight(
        (kToolbarHeight) +
            (bottomBuilder(appTheme)?.preferredSize.height ??
                BoxSize.boxSizeNone),
      );
}

///region appbar step widget
final class AppBarStepWidget extends _AppBarBase {
  final int currentStep;
  final VoidCallback onViewMoreInformationTap;

  const AppBarStepWidget({
    super.key,
    super.onBack,
    required super.appTheme,
    this.currentStep = 1,
    required this.onViewMoreInformationTap,
  });

  @override
  PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
    return null;
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return _StepWidget(
      stepLength: 3,
      currentStep: currentStep,
      appTheme: appTheme,
    );
  }

  @override
  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme) {
    return [
      GestureDetector(
        onTap: onViewMoreInformationTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing04,
          ),
          child: SvgPicture.asset(
            AssetIconPath.commonInformation,
          ),
        ),
      ),
    ];
  }
}

final class _StepWidget extends StatelessWidget {
  final int stepLength;
  final int currentStep;
  final AppTheme appTheme;

  const _StepWidget({
    required this.stepLength,
    required this.currentStep,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          stepLength,
              (index) {
            List<Widget> build = List.empty(growable: true);
            if (currentStep > index) {
              build.add(
                SvgPicture.asset(AssetIconPath.onBoardingSuccessStep),
              );

              if (index < stepLength - 1) {
                build.add(
                  HoLiZonTalDividerWidget(
                    dividerColor: appTheme.borderColorBrand,
                    width: BoxSize.boxSize10,
                  ),
                );
              }
            } else if (index == stepLength - 1) {
              build.add(
                SvgPicture.asset(AssetIconPath.onBoardingSuccessDisableStep),
              );
            } else if (index == currentStep) {
              build.add(
                SvgPicture.asset(AssetIconPath.onBoardingActiveStep),
              );
              build.add(
                HoLiZonTalDividerWidget(
                  dividerColor: appTheme.borderColorBrand,
                  width: BoxSize.boxSize10,
                ),
              );
            } else {
              build.add(
                SvgPicture.asset(AssetIconPath.onBoardingDisableStep),
              );

              build.add(
                const HoLiZonTalDividerWidget(
                  width: BoxSize.boxSize10,
                ),
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: build,
            );
          },
        ),
      ),
    );
  }
}

///endregion
