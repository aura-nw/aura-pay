import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

class DisconnectConfirmationContentWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String address;

  const DisconnectConfirmationContentWidget({
    required this.appTheme,
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.connectSiteScreenDisconnectTitle,
              ),
              style: AppTypoGraPhy.heading02.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return RichText(
              text: TextSpan(
                style: AppTypoGraPhy.body02.copyWith(
                  color: appTheme.contentColor500,
                ),
                children: [
                  TextSpan(
                    text: localization.translate(
                      LanguageKey.connectSiteScreenDisconnectContentRegionOne,
                    ),
                  ),
                  TextSpan(
                    text: ' ${address.addressView}',
                    style: AppTypoGraPhy.bodyMedium03.copyWith(
                      color: appTheme.contentColorDanger,
                    ),
                  ),
                  const TextSpan(
                    text: '? '
                  ),
                  TextSpan(
                    text: localization.translate(
                      LanguageKey.connectSiteScreenDisconnectContentRegionTwo,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
