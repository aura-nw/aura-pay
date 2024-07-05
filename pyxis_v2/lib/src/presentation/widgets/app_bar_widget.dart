import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/constants/typography.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_v2/src/navigator.dart';

abstract interface class _AppBarBase extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final AppTheme appTheme;
  final AppLocalizationManager localization;
  final double? leadingWidth;
  final Widget? title;
  final String? titleKey;

  const _AppBarBase({
    this.leadingWidth,
    this.onBack,
    required this.appTheme,
    required this.localization,
    this.titleKey,
    this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingBuilder(context, appTheme, localization) ??
          GestureDetector(
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
                AssetIconPath.icCommonArrowBack,
                height: BoxSize.boxSize07,
                width: BoxSize.boxSize07,
              ),
            ),
          ),
      leadingWidth: leadingWidth,
      title: titleBuilder(context, appTheme, localization),
      centerTitle: true,
      bottom: bottomBuilder(appTheme, localization),
      actions: actionBuilders(context, appTheme, localization),
      bottomOpacity: 0,
      backgroundColor: appTheme.bgPrimary,
      elevation: 0,
    );
  }

  Widget? leadingBuilder(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return null;
  }

  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return null;
  }

  PreferredSizeWidget? bottomBuilder(
      AppTheme appTheme, AppLocalizationManager localization) {
    return null;
  }

  Widget? titleBuilder(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    if (title != null) {
      return title;
    }

    if (titleKey.isNotNullOrEmpty) {
      return Text(
        localization.translate(titleKey!),
        style: AppTypoGraPhy.textMdBold.copyWith(
          color: appTheme.textPrimary,
        ),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        (kToolbarHeight) +
            (bottomBuilder(appTheme, localization)?.preferredSize.height ??
                BoxSize.boxSizeNone),
      );
}

///region home app bar
// class HomeAppBarWidget extends _AppBarBase {
//   final VoidCallback onNotificationTap;
//   final String chainName;
//
//   const HomeAppBarWidget({
//     required super.appTheme,
//     super.key,
//     required this.onNotificationTap,
//     required this.chainName,
//     super.leadingWidth,
//   });
//
//   @override
//   List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme) {
//     return [
//       GestureDetector(
//         onTap: onNotificationTap,
//         behavior: HitTestBehavior.opaque,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: Spacing.spacing05,
//           ),
//           child: SvgPicture.asset(
//             AssetIconPath.homeAppBarNotification,
//           ),
//         ),
//       ),
//     ];
//   }
//
//   @override
//   PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
//     return null;
//   }
//
//   @override
//   Widget titleBuilder(BuildContext context, AppTheme appTheme) {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: Spacing.spacing03,
//         vertical: Spacing.spacing02,
//       ),
//       decoration: BoxDecoration(
//         color: appTheme.surfaceColorGrayDefault,
//         borderRadius: BorderRadius.circular(
//           BorderRadiusSize.borderRadius05,
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             AssetIconPath.commonAura,
//           ),
//           const SizedBox(
//             width: BoxSize.boxSize02,
//           ),
//           Text(
//             chainName,
//             style: AppTypoGraPhy.body02.copyWith(
//               color: appTheme.contentColorBlack,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget? leadingBuilder(BuildContext context, AppTheme appTheme) {
//     return Row(
//       children: [
//         const SizedBox(
//           width: BoxSize.boxSize05,
//         ),
//         SvgPicture.asset(
//           AssetIconPath.inAppBrowserLogo,
//         ),
//       ],
//     );
//   }
// }

///

/// region app bar with title non leading
class AppBarWithOnlyTitle extends _AppBarBase {
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const AppBarWithOnlyTitle({
    required super.appTheme,
    super.key,
    super.onBack,
    super.title,
    this.leading,
    super.titleKey,
    this.actions,
    this.bottom,
    required super.localization,
  });

  @override
  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return actions;
  }

  @override
  PreferredSizeWidget? bottomBuilder(
      AppTheme appTheme, AppLocalizationManager localization) {
    return bottom;
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return const SizedBox();
  }
}

///

/// region app bar with title non leading
class AppBarDefault extends _AppBarBase {
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const AppBarDefault({
    required super.appTheme,
    super.key,
    super.onBack,
    super.title,
    this.leading,
    super.titleKey,
    this.actions,
    this.bottom,
    required super.localization,
    super.leadingWidth,
  });

  @override
  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return actions;
  }

  @override
  PreferredSizeWidget? bottomBuilder(
      AppTheme appTheme, AppLocalizationManager localization) {
    return bottom;
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return leading;
  }
}

///
