import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:shimmer/shimmer.dart';

final class NFTVerticalCard extends StatelessWidget {
  final String name;
  final String url;
  final AppTheme appTheme;
  final String idToken;

  const NFTVerticalCard({
    super.key,
    required this.name,
    required this.url,
    required this.appTheme,
    required this.idToken,
  });

  static const double _logoSize = 56;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadius03,
            ),
            child: Stack(
              children: [
                CacheNetworkImageExtend(
                  imageUrl: url,
                  targetWidth: context.cacheImageTarget,
                  targetHeight: context.cacheImageTarget,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  loadingBuilder: (context, url, onProcess) {
                    return Shimmer.fromColors(
                      baseColor: appTheme.surfaceColorGrayDefault,
                      highlightColor: appTheme.surfaceColorBrandSemiLight,
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                          color: appTheme.primaryColor50,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, url, error) {
                    return Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        color: appTheme.primaryColor50,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AssetLogoPath.logoOpacity,
                        height: _logoSize,
                        width: _logoSize,
                      ),
                    );
                  },
                ),
                Positioned(
                  top: Spacing.spacing03,
                  right: Spacing.spacing03,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Spacing.spacing01,
                      horizontal: Spacing.spacing03,
                    ),
                    decoration: BoxDecoration(
                      color: appTheme.surfaceColorBlack.withOpacity(
                        0.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        BorderRadiusSize.borderRadiusRound,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      idToken,
                      style: AppTypoGraPhy.body01.copyWith(
                        color: appTheme.contentColorWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        Text(
          name,
          style: AppTypoGraPhy.body01.copyWith(
            color: appTheme.contentColorBlack,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

}
