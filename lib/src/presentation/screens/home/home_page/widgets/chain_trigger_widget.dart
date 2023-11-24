import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';

class ChainTriggerWidget extends StatelessWidget {
  final AppTheme appTheme;

  const ChainTriggerWidget({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing03,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(
            BorderRadiusSize.borderRadius05,
          ),
          topLeft: Radius.circular(
            BorderRadiusSize.borderRadius05,
          ),
        ),
        gradient: LinearGradient(
          colors: [
            appTheme.surfaceColorBrandLight,
            appTheme.surfaceColorBrandLight.withOpacity(0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _triggerBuilder(
                  AssetIconPath.homeSendToken,
                  LanguageKey.homePageSendToken,
                ),
              ),
              Expanded(
                child: _triggerBuilder(
                  AssetIconPath.homeReceiveToken,
                  LanguageKey.homePageReceiveToken,
                ),
              ),
              Expanded(
                child: _triggerBuilder(
                  AssetIconPath.homeNFTs,
                  LanguageKey.homePageNFTs,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: BoxSize.boxSize07,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _triggerBuilder(
                  AssetIconPath.homeTxLimit,
                  LanguageKey.homePageTxLimit,
                ),
              ),
              Expanded(
                child: _triggerBuilder(
                  AssetIconPath.homeStake,
                  LanguageKey.homePageStake,
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _triggerBuilder(
    String iconPath,
    String triggerPath,
  ) {
    return Column(
      children: [
        SvgPicture.asset(
          iconPath,
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                triggerPath,
              ),
            );
          },
        ),
      ],
    );
  }
}
