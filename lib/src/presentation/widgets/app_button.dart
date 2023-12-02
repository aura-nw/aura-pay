import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:flutter/material.dart';

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

  final AppTheme theme;

  final Color? borderColor;

  _AppButton({
    Key? key,
    required this.text,
    this.onPress,
    this.color,
    this.borderColor,
    this.disableColor,
    this.gradient,
    this.minWidth,
    this.leading,
    bool? loading,
    bool? disabled,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    required this.theme,
    required this.textStyle,
  })  : assert(color == null || gradient == null),
        loading = loading ?? false,
        disabled = (disabled ?? false) || (loading ?? false),
        padding = padding ?? const EdgeInsets.all(Spacing.spacing05),
        borderRadius = borderRadius ??
            BorderRadius.circular(BorderRadiusSize.borderRadiusRound),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.surfaceColorWhite,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          color: disabled ? disableColor : color,
          gradient: disabled ? null : gradient,
          borderRadius: borderRadius,
          border: borderColor != null
              ? Border.all(
                  color: borderColor!,
                )
              : null,
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
  final Widget? leading;
  final bool? isDisable;
  final VoidCallback? onPress;
  final double? minWidth;
  final Color? backGroundColor;

  const PrimaryAppButton({
    super.key,
    required this.text,
    this.isDisable,
    this.leading,
    this.onPress,
    this.minWidth,
    this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return _AppButton(
          text: text,
          disabled: isDisable,
          onPress: onPress,
          color: backGroundColor ?? theme.primaryDefault,
          disableColor: theme.primaryColor50,
          minWidth: minWidth,
          textStyle: AppTypoGraPhy.bodyMedium03.copyWith(
            color: theme.contentColorWhite,
          ),
          theme: theme,
          leading: leading,
        );
      },
    );
  }
}

final class BorderAppButton extends StatelessWidget {
  final String text;
  final bool? isDisable;
  final VoidCallback? onPress;
  final double? minWidth;
  final Color? borderColor;
  final Color? textColor;

  const BorderAppButton({
    super.key,
    required this.text,
    this.isDisable,
    this.onPress,
    this.minWidth,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return _AppButton(
          text: text,
          disabled: isDisable,
          onPress: onPress,
          minWidth: minWidth,
          textStyle: AppTypoGraPhy.bodyMedium03.copyWith(
            color: textColor ?? theme.contentColorBrand,
          ),
          theme: theme,
          borderColor: borderColor ?? theme.borderColorBrand,
        );
      },
    );
  }
}

final class TextAppButton extends StatelessWidget {
  final String text;
  final bool? isDisable;
  final VoidCallback? onPress;
  final double? minWidth;

  const TextAppButton({
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
          color: theme.bodyColorBackground,
          minWidth: minWidth,
          textStyle: AppTypoGraPhy.bodyMedium03.copyWith(
            color: theme.contentColor700,
          ),
          theme: theme,
        );
      },
    );
  }
}
