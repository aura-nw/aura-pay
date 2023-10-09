import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

abstract interface class _DialogProviderWidget extends StatelessWidget {
  const _DialogProviderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.spacing06,
          vertical: Spacing.spacing05,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (headerBuilder(context, appTheme) != null) ...[
              headerBuilder(context, appTheme)!,
              const SizedBox(
                height: BoxSize.boxSize06,
              ),
            ],
            SingleChildScrollView(
              child: contentBuilder(context, appTheme),
            ),
            if (bottomBuilder(context, appTheme) != null) ...[
              const SizedBox(
                height: BoxSize.boxSize06,
              ),
              bottomBuilder(context, appTheme)!,
            ]
          ],
        ),
      ),
    );
  }

  Widget contentBuilder(BuildContext context, AppTheme appTheme);

  Widget? bottomBuilder(BuildContext content, AppTheme appTheme);

  Widget? headerBuilder(BuildContext context, AppTheme appTheme);
}

final class _LoadingDialog extends _DialogProviderWidget {
  final String content;

  const _LoadingDialog({
    required this.content,
    super.key,
  });

  @override
  Widget? bottomBuilder(BuildContext content, AppTheme appTheme) {
    return null;
  }

  @override
  Widget contentBuilder(BuildContext context, AppTheme appTheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(AssetIconPath.commonLogoSmall),
        const SizedBox(
          height: BoxSize.boxSize08,
        ),
        Text(
          content,
          style: AppTypoGraPhy.body02.copyWith(
            color: appTheme.contentColor500,
          ),
        ),
      ],
    );
  }

  @override
  Widget? headerBuilder(BuildContext context, AppTheme appTheme) {
    return null;
  }
}

final class _WarningDialog extends _DialogProviderWidget {
  final String title;
  final String message;
  final String buttonTitle;
  final VoidCallback? onButtonTap;

  const _WarningDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonTitle,
    this.onButtonTap,
  });

  @override
  Widget? bottomBuilder(BuildContext content, AppTheme appTheme) {
    return PrimaryAppButton(
      text: buttonTitle,
      onPress: onButtonTap,
    );
  }

  @override
  Widget contentBuilder(BuildContext context, AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTypoGraPhy.heading02.copyWith(
            color: appTheme.contentColorBlack,
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        Text(
          message,
          style: AppTypoGraPhy.body02.copyWith(
            color: appTheme.contentColor500,
          ),
        ),
      ],
    );
  }

  @override
  Widget? headerBuilder(BuildContext context, AppTheme appTheme) {
    return SvgPicture.asset(AssetIconPath.commonWarning);
  }
}

sealed class DialogProvider {
  static Widget _mainDialog(
    Widget child, {
    bool canBack = true,
    required AppTheme appTheme,
    EdgeInsets? insetPadding,
  }) {
    return WillPopScope(
      onWillPop: () async {
        return canBack;
      },
      child: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius06,
          ),
        ),
        backgroundColor: appTheme.bodyColorBackground,
        insetPadding: insetPadding ??
            const EdgeInsets.symmetric(
              horizontal: Spacing.spacing05,
              vertical: Spacing.spacing04,
            ),
        child: child,
      ),
    );
  }

  static Future<T?> showWarningDialog<T>(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonTitle,
    VoidCallback? onButtonTap,
    required AppTheme appTheme,
  }) async {
    return showDialog<T?>(
      context: context,
      builder: (_) {
        return _mainDialog(
          _WarningDialog(
            title: title,
            message: message,
            buttonTitle: buttonTitle,
            onButtonTap: onButtonTap,
          ),
          appTheme: appTheme,
        );
      },
    );
  }

  static Future<void> showLoadingDialog(
    BuildContext context, {
    required String content,
    required AppTheme appTheme,
  }) async {
    showDialog(
      context: context,
      builder: (_) {
        return _mainDialog(
          _LoadingDialog(
            content: content,
          ),
          canBack: false,
          appTheme: appTheme,
        );
      },
    );
  }
}
