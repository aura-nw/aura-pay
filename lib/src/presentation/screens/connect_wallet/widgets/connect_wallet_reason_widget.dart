import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';

class ConnectWalletReasonWidget extends StatelessWidget {
  final AppTheme appTheme;

  const ConnectWalletReasonWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppTypoGraPhy.body03.copyWith(
      color: appTheme.contentColor700,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.connectWalletScreenReason,
              ),
              style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        IconWithTextWidget(
          titlePath: LanguageKey.connectWalletScreenReasonOne,
          svgIconPath: AssetIconPath.commonAccountCheck,
          appTheme: appTheme,
          style: style,
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        IconWithTextWidget(
          titlePath: LanguageKey.connectWalletScreenReasonTwo,
          svgIconPath: AssetIconPath.commonAccountCheck,
          appTheme: appTheme,
          style: style,
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        IconWithTextWidget(
          titlePath: LanguageKey.connectWalletScreenReasonThree,
          svgIconPath: AssetIconPath.connectWalletClose,
          appTheme: appTheme,
          style: style,
        ),
      ],
    );
  }
}
