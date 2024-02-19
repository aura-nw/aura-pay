import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:shimmer/shimmer.dart';

class SiteWidget extends StatelessWidget {
  final String logo;
  final String siteName;
  final String siteUrl;
  final AppTheme appTheme;

  const SiteWidget({
    required this.logo,
    required this.siteName,
    required this.siteUrl,
    required this.appTheme,
    super.key,
  });

  static const double _size = 40;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: Spacing.spacing05, bottom: Spacing.spacing05),
      child: Row(
        children: [
          CacheNetworkImageExtend(
            imageUrl: logo,
            targetWidth: _size * 4,
            targetHeight: _size * 4,
            width: _size,
            height: _size,
            loadingBuilder: (context, url, onProcess) {
              return Shimmer.fromColors(
                baseColor: appTheme.surfaceColorGrayDefault,
                highlightColor: appTheme.surfaceColorBrandSemiLight,
                child: Container(
                  width: _size,
                  height: _size,
                  decoration: BoxDecoration(
                    color: appTheme.primaryColor50,
                  ),
                ),
              );
            },
            errorBuilder: (context, url, error) {
              return Container(
                width: _size,
                height: _size,
                decoration: BoxDecoration(
                  color: appTheme.primaryColor50,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AssetLogoPath.logoOpacity,
                ),
              );
            },
          ),
          const SizedBox(
            width: BoxSize.boxSize05,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  siteName,
                  style: AppTypoGraPhy.heading02.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                ),
                Text(
                  siteUrl,
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
