import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/nft_helper.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft_detail/widgets/nft_video_widget.dart';
import 'nft_image_widget.dart';

class NFTMediaBuilder extends StatelessWidget {
  final OffChainMediaInfo mediaInfo;
  final AppTheme appTheme;

  const NFTMediaBuilder({
    required this.mediaInfo,
    required this.appTheme,
    super.key,
  });

  MediaType get mediaType => NFTHelper.getMediaType(
        mediaInfo,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: context.h * 2 / 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius04,
        ),
      ),
      child: _buildLayout(),
    );
  }

  Widget _buildLayout() {
    switch (mediaType) {
      case MediaType.image:
        return NFTImageWidget(
          url: mediaInfo.image.url ?? '',
          appTheme: appTheme,
        );
      case MediaType.video:
        return NFTVideoWidget(
          thumbUrl: mediaInfo.image.url ?? '',
          source: mediaInfo.animation?.url,
          appTheme: appTheme,
        );
      case MediaType.audio:
        return NFTImageWidget(
          url: mediaInfo.image.url ?? '',
          appTheme: appTheme,
        );
    }
  }
}
