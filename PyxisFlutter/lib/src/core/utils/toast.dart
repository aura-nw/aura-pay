import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/cubit/theme_cubit.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

mixin CustomFlutterToast<T extends StatefulWidget> on State<T> {
  late FToast _fToast;

  void _init() {
    _fToast = FToast();
    _fToast.init(
      AppNavigator.navigatorKey.currentContext ?? context,
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _fToast.removeCustomToast();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    _init();
  }

  Widget _buildToast(String message) {
    final AppTheme theme = AppThemeCubit.of(context).state;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing03,
        vertical: Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius03,
        ),
        color: theme.surfaceColorBlack,
      ),
      child: Text(
        message,
        style: AppTypoGraPhy.bodyMedium03.copyWith(
          color: theme.contentColorWhite,
        ),
      ),
    );
  }

  Widget _buildSuccessToast(String message) {
    final AppTheme theme = AppThemeCubit.of(context).state;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing03,
        vertical: Spacing.spacing04,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius03,
        ),
        color: theme.surfaceColorBlack,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetIconPath.commonCheckSuccess,
          ),
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          Text(
            message,
            style: AppTypoGraPhy.bodyMedium03.copyWith(
              color: theme.contentColorWhite,
            ),
          ),
        ],
      ),
    );
  }

  void showToast(
    String message, [
    Duration duration = const Duration(
      milliseconds: 2200,
    ),
  ]) {
    _fToast.showToast(
      child: _buildToast(message),
      gravity: ToastGravity.BOTTOM,
      toastDuration: duration,
    );
  }

  void showSuccessToast(
    String message, [
    Duration duration = const Duration(
      milliseconds: 2200,
    ),
  ]) {
    _fToast.showToast(
      child: _buildSuccessToast(
        message,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: duration,
    );
  }
}
