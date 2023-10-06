import 'package:flutter/material.dart';

/// [AppTheme] defines pyxis mobile application's design system.
interface class AppTheme {
  ///region Primary color
  late Color primaryDefault;
  late Color primaryColor10;
  late Color primaryColor25;
  late Color primaryColor50;
  late Color primaryColor100;
  late Color primaryColor200;
  late Color primaryColor300;
  late Color primaryColor400;
  late Color primaryColor500;
  late Color primaryColor600;
  late Color primaryColor700;
  late Color primaryColor800;
  late Color primaryColor900;

  ///region Secondary color
  late Color secondaryDefault;
  late Color secondary50;
  late Color secondary100;
  late Color secondary200;
  late Color secondary300;
  late Color secondary400;
  late Color secondary500;
  late Color secondary600;
  late Color secondary700;
  late Color secondary800;
  late Color secondary900;

  ///region Tertiary color
  late Color tertiaryDefault;
  late Color tertiary50;
  late Color tertiary100;
  late Color tertiary200;
  late Color tertiary300;
  late Color tertiary400;
  late Color tertiary500;
  late Color tertiary600;
  late Color tertiary700;
  late Color tertiary800;
  late Color tertiary900;

  /// Info color
  late Color infoDefault;
  late Color infoLight;
  late Color infoDark;

  /// Success color
  late Color successColorSLight;
  late Color successColorLight;
  late Color successColorDark;
  late Color successColorSDark;
  late Color successColorDefault;

  /// Warning color
  late Color warningColorSLight;
  late Color warningColorLight;
  late Color warningColorDark;
  late Color warningColorSDark;
  late Color warningColorDefault;

  /// Danger color
  late Color dangerColorSLight;
  late Color dangerColorLight;
  late Color dangerColorSDark;
  late Color dangerColorDark;
  late Color dangerColorDefault;

  /// Unknown color
  late Color unknownColorLight;
  late Color unknownColorDark;
  late Color unknownColorDefault;

  /// Surface color
  late Color surfaceColorWhite;
  late Color surfaceColorGrayLight;
  late Color surfaceColorGrayDefault;
  late Color surfaceColorGrayDark;
  late Color surfaceColorBlack;
  late Color surfaceColorDisable;
  late Color surfaceColorSuccess;
  late Color surfaceColorSuccessDark;
  late Color surfaceColorDanger;
  late Color surfaceColorDangerDark;
  late Color surfaceColorWarning;
  late Color surfaceColorWarningDark;
  late Color surfaceColorUnKnow;
  late Color surfaceColorBrandLight;
  late Color surfaceColorBrandSemiLight;
  late Color surfaceColorBrand;
  late Color surfaceColorBrandDark;

  /// Border color
  late Color borderColorWhite;
  late Color borderColorGrayLight;
  late Color borderColorGrayDefault;
  late Color borderColorGrayDark;
  late Color borderColorBlack;
  late Color borderColorDisable;
  late Color borderColorSuccess;
  late Color borderColorSuccessLight;
  late Color borderColorSuccessDark;
  late Color borderColorDangerLight;
  late Color borderColorDanger;
  late Color borderColorDangerDark;
  late Color borderColorWarningDark;
  late Color borderColorWarningLight;
  late Color borderColorWarning;
  late Color borderColorUnKnow;
  late Color borderColorBrand;
  late Color borderColorBrandSLight;
  late Color borderColorBrandLight;
  late Color borderColorBrandDark;

  /// Content color
  late Color contentColorWhite;
  late Color contentColor200;
  late Color contentColor300;
  late Color contentColor500;
  late Color contentColor700;
  late Color contentColorBlack;
  late Color contentColorOpacity1;
  late Color contentColorBrandLight;
  late Color contentColorBrand;
  late Color contentColorBrandDark;
  late Color contentColorSuccess;
  late Color contentColorDanger;
  late Color contentColorWarning;
  late Color contentColorUnKnow;

  /// Body color
  late Color bodyColorBrand;
  late Color bodyColorOverlay;
  late Color bodyColorBackground;
}