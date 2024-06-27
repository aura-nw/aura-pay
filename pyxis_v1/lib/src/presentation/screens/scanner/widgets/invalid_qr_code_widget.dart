import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class InValidQrCodeWidget extends StatelessWidget {
  final AppTheme appTheme;
  final VoidCallback onConfirm;

  const InValidQrCodeWidget({
    required this.appTheme,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing06,
        vertical: Spacing.spacing05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AssetIconPath.commonRemoveWarning,
          ),
          const SizedBox(
            height: BoxSize.boxSize06,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.scannerScreenInValidQrCode,
                ),
                style: AppTypoGraPhy.heading02.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          const SizedBox(
            height: BoxSize.boxSize08,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return PrimaryAppButton(
                text: localization.translate(
                  LanguageKey.scannerScreenConfirm,
                ),
                onPress: onConfirm,
              );
            },
          ),
        ],
      ),
    );
  }
}
