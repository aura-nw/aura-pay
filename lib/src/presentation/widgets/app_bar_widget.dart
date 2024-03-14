import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

abstract interface class _AppBarBase extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final AppTheme appTheme;
  final double? leadingWidth;

  const _AppBarBase({
    this.leadingWidth,
    this.onBack,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leadingBuilder(context, appTheme) ??
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
                AssetIconPath.commonArrowBack,
                height: BoxSize.boxSize07,
                width: BoxSize.boxSize07,
              ),
            ),
          ),
      leadingWidth: leadingWidth,
      title: titleBuilder(context, appTheme),
      centerTitle: true,
      bottom: bottomBuilder(appTheme),
      actions: actionBuilders(context, appTheme),
      bottomOpacity: 0,
      backgroundColor: appTheme.bodyColorBackground,
      elevation: 0,
    );
  }

  Widget? leadingBuilder(BuildContext context, AppTheme appTheme);

  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme);

  PreferredSizeWidget? bottomBuilder(AppTheme appTheme);

  Widget titleBuilder(BuildContext context, AppTheme appTheme);

  @override
  Size get preferredSize => Size.fromHeight(
        (kToolbarHeight) +
            (bottomBuilder(appTheme)?.preferredSize.height ??
                BoxSize.boxSizeNone),
      );
}

///region appbar normal widget
final class NormalAppBarWidget extends _AppBarBase {
  final VoidCallback onViewMoreInformationTap;

  const NormalAppBarWidget({
    required this.onViewMoreInformationTap,
    required super.appTheme,
    super.onBack,
    super.key,
  });

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

  @override
  PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
    return null;
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox();
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme) {
    return null;
  }
}

///endregion


///region appbar normal with title widget
final class NormalAppBarWithTitleWidget extends _AppBarBase {
  final VoidCallback onViewMoreInformationTap;
  final String title;

  const NormalAppBarWithTitleWidget({
    required this.onViewMoreInformationTap,
    required this.title,
    required super.appTheme,
    super.onBack,
    super.key,
  });

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

  @override
  PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
    return null;
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return Text(
      title,
      style: AppTypoGraPhy.heading03.copyWith(
        color: appTheme.contentColorBlack,
      ),
    );
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme) {
    return null;
  }
}

///endregion

///region appbar normal with title widget
final class NormalAppBarWithOnlyTitleWidget extends _AppBarBase {
  final VoidCallback onViewMoreInformationTap;
  final String title;

  const NormalAppBarWithOnlyTitleWidget({
    required this.onViewMoreInformationTap,
    required this.title,
    required super.appTheme,
    super.onBack,
    super.key,
  });

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

  @override
  PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
    return null;
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return Text(
      title,
      style: AppTypoGraPhy.heading03.copyWith(
        color: appTheme.contentColorBlack,
      ),
    );
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox.shrink();
  }
}

///endregion

///region home app bar
class HomeAppBarWidget extends _AppBarBase {
  final VoidCallback onNotificationTap;
  final String chainName;

  const HomeAppBarWidget({
    required super.appTheme,
    super.key,
    required this.onNotificationTap,
    required this.chainName,
    super.leadingWidth,
  });

  @override
  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme) {
    return [
      GestureDetector(
        onTap: onNotificationTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing05,
          ),
          child: SvgPicture.asset(
            AssetIconPath.homeAppBarNotification,
          ),
        ),
      ),
    ];
  }

  @override
  PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
    return null;
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing03,
        vertical: Spacing.spacing02,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayDefault,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius05,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AssetIconPath.commonAura,
          ),
          const SizedBox(
            width: BoxSize.boxSize02,
          ),
          Text(
            chainName,
            style: AppTypoGraPhy.body02.copyWith(
              color: appTheme.contentColorBlack,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme) {
    return Row(
      children: [
        const SizedBox(
          width: BoxSize.boxSize05,
        ),
        SvgPicture.asset(
          AssetIconPath.inAppBrowserLogo,
        ),
      ],
    );
  }
}

///

/// region app bar with title
class AppBarWithTitle extends _AppBarBase {
  final String titleKey;

  const AppBarWithTitle({
    required super.appTheme,
    super.key,
    super.onBack,
    required this.titleKey,
  });

  @override
  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme) {
    return null;
  }

  @override
  PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
    return null;
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme) {
    return null;
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Text(
          localization.translate(
            titleKey,
          ),
          style: AppTypoGraPhy.heading03.copyWith(
            color: appTheme.contentColorBlack,
          ),
        );
      },
    );
  }
}

///

/// region app bar with title non leading
class AppBarWithOnlyTitle extends _AppBarBase {
  final String titleKey;

  const AppBarWithOnlyTitle({
    required super.appTheme,
    super.key,
    super.onBack,
    required this.titleKey,
  });

  @override
  List<Widget>? actionBuilders(BuildContext context, AppTheme appTheme) {
    return null;
  }

  @override
  PreferredSizeWidget? bottomBuilder(AppTheme appTheme) {
    return null;
  }

  @override
  Widget? leadingBuilder(BuildContext context, AppTheme appTheme) {
    return const SizedBox();
  }

  @override
  Widget titleBuilder(BuildContext context, AppTheme appTheme) {
    return AppLocalizationProvider(
      builder: (localization, _) {
        return Text(
          localization.translate(
            titleKey,
          ),
          style: AppTypoGraPhy.heading03.copyWith(
            color: appTheme.contentColorBlack,
          ),
        );
      },
    );
  }
}

///
