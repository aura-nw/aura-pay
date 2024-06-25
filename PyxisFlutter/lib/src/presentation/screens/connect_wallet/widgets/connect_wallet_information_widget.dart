import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'package:shimmer/shimmer.dart';

class ConnectWalletInformationWidget extends StatelessWidget {
  final String url;
  final String logo;
  final AppTheme appTheme;

  const ConnectWalletInformationWidget({
    required this.url,
    required this.logo,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadiusRound,
          ),
          child: CacheNetworkImageExtend(
            imageUrl: logo,
            targetWidth: BoxSize.boxSize10 * 2,
            targetHeight: BoxSize.boxSize10 * 2,
            width: BoxSize.boxSize11,
            loadingBuilder: (context, url, onProcess) {
              return Shimmer.fromColors(
                baseColor: appTheme.surfaceColorGrayDefault,
                highlightColor: appTheme.surfaceColorBrandSemiLight,
                child: Container(
                  width: BoxSize.boxSize11,
                  height: BoxSize.boxSize11,
                  decoration: BoxDecoration(
                    color: appTheme.primaryColor50,
                  ),
                ),
              );
            },
            errorBuilder: (context, url, error) {
              return Container(
                width: BoxSize.boxSize11,
                height: BoxSize.boxSize11,
                decoration: BoxDecoration(
                  color: appTheme.primaryColor50,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AssetIconPath.commonGoogle,
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.connectWalletScreenConnectToSite,
              ),
              style: AppTypoGraPhy.heading01.copyWith(
                color: appTheme.contentColor700,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize03,
        ),
        IconWithTextWidget(
          titlePath: url,
          svgIconPath: AssetIconPath.connectWalletLock,
          appTheme: appTheme,
          style: AppTypoGraPhy.bodyMedium03.copyWith(
            color: appTheme.contentColorSuccess,
          ),
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ],
    );
  }
}
