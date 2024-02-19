import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:shimmer/shimmer.dart';

class BrowserSuggestionWidget extends StatelessWidget {
  final String logo;
  final String name;
  final String description;
  final AppTheme appTheme;
  final Widget suffix;

  const BrowserSuggestionWidget({
    super.key,
    required this.name,
    required this.description,
    required this.logo,
    required this.appTheme,
    required this.suffix,
  });

  static const double _size = 50;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CacheNetworkImageExtend(
          imageUrl: logo,
          targetWidth: _size * 4,
          targetHeight: _size * 4,
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
                name,
                style: AppTypoGraPhy.heading02.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              ),
              const SizedBox(
                height: BoxSize.boxSize04,
              ),
              Text(
                description,
                style: AppTypoGraPhy.body02.copyWith(
                  color: appTheme.contentColor500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize05,
        ),
        suffix,
      ],
    );
  }
}
