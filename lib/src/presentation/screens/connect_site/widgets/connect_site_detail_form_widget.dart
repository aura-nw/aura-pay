import 'package:cache_network_image_extended/cache_network_image_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';
import 'package:shimmer/shimmer.dart';

class ConnectSiteDetailFormWidget extends StatelessWidget {
  final String logo;
  final String siteName;
  final String url;
  final String date;
  final String accountName;
  final String address;
  final String connectType;
  final AppTheme appTheme;
  final VoidCallback onDisConnect;

  const ConnectSiteDetailFormWidget({
    required this.siteName,
    required this.logo,
    required this.date,
    required this.address,
    required this.url,
    required this.accountName,
    required this.connectType,
    required this.appTheme,
    required this.onDisConnect,
    super.key,
  });

  static const double _size = 50;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing06,
        vertical: Spacing.spacing05,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScrollViewWidget(
            appTheme: appTheme,
          ),
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              BorderRadiusSize.borderRadiusRound,
            ),
            child: CacheNetworkImageExtend(
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
          ),
          const SizedBox(
            height: BoxSize.boxSize04,
          ),
          Container(
            padding: const EdgeInsets.all(
              Spacing.spacing05,
            ),
            margin: const EdgeInsets.only(
              bottom: BoxSize.boxSize08,
            ),
            decoration: BoxDecoration(
              color: appTheme.surfaceColorGrayLight,
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius04,
              ),
            ),
            child: Column(
              children: [
                // _buildInformation(
                //   LanguageKey.connectSiteScreenDate,
                //   date,
                // ),
                _buildInformation(
                  LanguageKey.connectSiteScreenAccountName,
                  accountName,
                ),
                _buildInformation(
                  LanguageKey.connectSiteScreenAddress,
                  address.addressView,
                ),
                _buildInformation(
                  LanguageKey.connectSiteScreenConnectionType,
                  connectType,
                ),
              ],
            ),
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return BorderAppButton(
                textColor: appTheme.contentColorDanger,
                borderColor: appTheme.borderColorDanger,
                text: localization.translate(
                  LanguageKey.connectSiteScreenDisconnect,
                ),
                onPress: onDisConnect,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInformation(String titleKey, String value) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  titleKey,
                ),
                style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          Text(
            value,
            style: AppTypoGraPhy.body03.copyWith(
              color: appTheme.contentColorBlack,
            ),
          ),
        ],
      ),
    );
  }
}
