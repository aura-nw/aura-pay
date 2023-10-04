import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
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

class AppButton extends StatelessWidget {
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

  AppButton({
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
    TextStyle? textStyle,
  })  : assert(color == null || gradient == null),
        loading = loading ?? false,
        disabled = (disabled ?? false) || (loading ?? false),
        padding = padding ?? const EdgeInsets.all(16),
        borderRadius = borderRadius ?? BorderRadius.circular(16),
        textStyle = textStyle ?? AppTypoGraPhy.button16,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Ink(
        decoration: BoxDecoration(
          color: disabled ? disableColor : color,
          gradient: disabled ? null : gradient,
        ),
        child: InkWell(
          splashColor: Colors.white10,
          highlightColor: Colors.white10,
          onTap: disabled ? null : onPress,
          child: Container(
            constraints:
                minWidth != null ? BoxConstraints(minWidth: minWidth!) : null,
            padding: padding,
            alignment: Alignment.center,
            child: loading
                ? SizedBox.square(
                    dimension: 19.2,
                    child: CircularProgressIndicator(color: textStyle.color))
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
