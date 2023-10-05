import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';

final class DefaultAppTheme implements AppTheme {
  DefaultAppTheme();

  @override
  Color borderColorGray = const Color(0xffdedee3);

  @override
  Color primaryColor400 = const Color(0xff9994ff);

  @override
  Color primaryColor50 = const Color(0xffdddbff);

  @override
  Color primaryColor500 = const Color(0xff8580ff);

  @override
  Color primaryColor800 = const Color(0xff454385);

  @override
  Color surfaceColorGray = const Color(0xffececee);

  @override
  Color surfaceColorWhite = const Color(0xffffffff);

  @override
  Color surfaceGrayColorLight = const Color(0xfff7f7f8);

  @override
  Color tertiaryColor900 = const Color(0xff45475c);

  @override
  Color contentColor700 = const Color(0xff5b5b67);

  @override
  Color contentColorBlack = const Color(0xff474752);

  @override
  Color contentColorBrand = const Color(0xff8580ff);

  @override
  Color contentColorWhite = const Color(0xffffffff);
}
