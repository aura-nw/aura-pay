import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:shimmer/shimmer.dart';

class NFTImageWidget extends StatelessWidget {
  final String url;
  final AppTheme appTheme;

  const NFTImageWidget({
    super.key,
    required this.url,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        BorderRadiusSize.borderRadius04,
      ),
      child: CacheNetworkImageExtend(
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
            ),
          );
        },
      ),
    );
  }
}
