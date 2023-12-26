import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:shimmer/shimmer.dart';

final class NFTHorizontalCard extends StatelessWidget {
  final String name;
  final String url;
  final String createAt;
  final AppTheme appTheme;
  final String idToken;

  const NFTHorizontalCard({
    super.key,
    required this.name,
    required this.url,
    required this.createAt,
    required this.appTheme,
    required this.idToken,
  });

  static const double _width = 100;
  static const double _height = 70;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius03,
          ),
          child: CacheNetworkImageExtend(
            imageUrl: url,
            targetWidth: context.cacheImageTarget,
            targetHeight: context.cacheImageTarget,
            fit: BoxFit.cover,
            width: _width,
            height: _height,
            loadingBuilder: (context, url, onProcess) {
              return Shimmer.fromColors(
                baseColor: appTheme.surfaceColorGrayDefault,
                highlightColor: appTheme.surfaceColorBrandSemiLight,
                child: const SizedBox(
                  width: _width,
                  height: _height,
                ),
              );
            },
            errorBuilder: (context, url, error) {
              return Shimmer.fromColors(
                baseColor: appTheme.surfaceColorGrayDefault,
                highlightColor: appTheme.surfaceColorBrandSemiLight,
                child: const SizedBox(
                  width: _width,
                  height: _height,
                ),
              );
            },
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTypoGraPhy.heading01.copyWith(
                  color: appTheme.contentColorBlack,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: BoxSize.boxSize02,
              ),
              Text(
                createAt,
                style: AppTypoGraPhy.body01.copyWith(
                  color: appTheme.contentColor500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize04,
        ),
        Text(
          idToken,
          style: AppTypoGraPhy.body01.copyWith(
            color: appTheme.contentColor500,
          ),
        ),
      ],
    );
  }
}
