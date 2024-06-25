import 'dart:io';

import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:shimmer/shimmer.dart';

class BrowserHistoryWidget extends StatelessWidget {
  final String logo;
  final String siteName;
  final String imageUri;
  final AppTheme appTheme;
  final VoidCallback onClose;

  const BrowserHistoryWidget({
    required this.logo,
    required this.siteName,
    required this.imageUri,
    required this.appTheme,
    required this.onClose,
    super.key,
  });

  static const double _size = 16;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing02,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayDefault,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing02,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    BorderRadiusSize.borderRadius04,
                  ),
                  child: CacheNetworkImageExtend(
                    imageUrl: logo,
                    targetWidth: _size * 4,
                    targetHeight: _size * 4,
                    width: _size,
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
                          AssetIconPath.commonGoogle,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: BoxSize.boxSize04,
                ),
                Expanded(
                  child: Text(
                    siteName,
                    style: AppTypoGraPhy.bodyMedium01.copyWith(
                      color: appTheme.contentColorBlack,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: BoxSize.boxSize05,
                ),
                GestureDetector(
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    AssetIconPath.commonClose,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius04,
              ),
              child: Image(
                fit: BoxFit.cover,
                image: FileImage(
                  File(imageUri),
                ),
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: appTheme.surfaceColorGrayLight,
                  );
                },
                width: double.maxFinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
