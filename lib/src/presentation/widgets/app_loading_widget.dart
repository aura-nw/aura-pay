import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class AppLoadingWidget extends StatefulWidget {
  final AppTheme appTheme;

  const AppLoadingWidget({
    required this.appTheme,
    super.key,
  });

  @override
  State<AppLoadingWidget> createState() => _AppLoadingWidgetState();
}

class _AppLoadingWidgetState extends State<AppLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
      reverseDuration: const Duration(
        milliseconds: 1200,
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return CustomPaint(
          painter: _AppLoadingCustomPaint(
            activeColors: [
              widget.appTheme.primaryColor500,
              widget.appTheme.primaryColor200,
              widget.appTheme.primaryColor50,
            ],
            completePercent: _controller.value,
            strokeWidth: BoxSize.boxSize03,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.spacing03),
            child: SvgPicture.asset(
              AssetIconPath.commonLogoSmall,
            ),
          ),
        );
      },
    );
  }
}

class _AppLoadingCustomPaint extends CustomPainter {
  final List<Color> activeColors;
  final double completePercent;
  final double strokeWidth;

  const _AppLoadingCustomPaint({
    required this.activeColors,
    required this.completePercent,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = min(size.width / 2, size.height / 2);

    Paint paint = Paint()
      ..shader = SweepGradient(colors: activeColors).createShader(
        Rect.fromLTRB(
          0,
          0,
          radius,
          radius,
        ),
      )
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
