import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/cubit/theme_cubit.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:flutter/material.dart';

extension RadiusX on Radius {
  Radius subtract(double value) => Radius.elliptical(x - value, y - value);
}

extension BorderRadiusX on BorderRadius {
  BorderRadius subtractBy(double value) => copyWith(
        topLeft: topLeft.subtract(1),
        topRight: topRight.subtract(1),
        bottomLeft: bottomLeft.subtract(1),
        bottomRight: bottomRight.subtract(1),
      );
}

class _AppButton extends StatelessWidget {
  final String text;
  final Widget? leading;
  final TextStyle textStyle;

  final Color? color;
  final Color? disableColor;
  final Gradient? gradient;

  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final double? minWidth;

  final bool disabled;
  final bool loading;

  final void Function()? onPress;

  _AppButton({
    Key? key,
    required this.text,
    this.onPress,
    this.color,
    this.disableColor,
    this.gradient,
    this.minWidth,
    this.leading,
    bool? loading,
    bool? disabled,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    required this.textStyle,
  })  : assert(color == null || gradient == null),
        loading = loading ?? false,
        disabled = (disabled ?? false) || (loading ?? false),
        padding = padding ?? const EdgeInsets.all(Spacing.spacing05),
        borderRadius =
            borderRadius ?? BorderRadius.circular(BorderRadiusSize.borderRadiusRound),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppTheme theme = AppThemeCubit.of(context).state;
    return Material(
      color: theme.surfaceColorWhite,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          color: disabled ? disableColor : color,
          gradient: disabled ? null : gradient,
        ),
        child: InkWell(
          splashColor: theme.primaryColor50,
          highlightColor: theme.primaryColor50,
          onTap: disabled ? null : onPress,
          child: Container(
            constraints:
                minWidth != null ? BoxConstraints(minWidth: minWidth!) : null,
            padding: padding,
            alignment: Alignment.center,
            child: loading
                ? SizedBox.square(
                    dimension: 19.2,
                    child: CircularProgressIndicator(color: textStyle.color),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      leading ?? const SizedBox.shrink(),
                      if (leading != null)
                        const SizedBox(
                          width: 7,
                        ),
                      Text(text, style: textStyle),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

final class PrimaryAppButton extends StatelessWidget {
  final String text;
  final bool? isDisable;
  final VoidCallback? onPress;
  final double? minWidth;

  const PrimaryAppButton({
    super.key,
    required this.text,
    this.isDisable,
    this.onPress,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return _AppButton(
          text: text,
          disabled: isDisable,
          onPress: onPress,
          color: theme.primaryDefault,
          disableColor: theme.primaryColor50,
          minWidth: minWidth,
          textStyle: AppTypoGraPhy.bodyMedium03.copyWith(
            color: theme.contentColorWhite,
          ),
        );
      },
    );
  }
}
