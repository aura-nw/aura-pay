import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_selector.dart';

class NFTCountWidget extends StatelessWidget {
  final AppTheme appTheme;

  const NFTCountWidget({
    super.key,
    required this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    LanguageKey.nftScreenTotal,
                  ),
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                );
              },
            ),
            const SizedBox(
              height: BoxSize.boxSize02,
            ),
            NFTTotalCountSelector(
              builder: (total) {
                return Text(
                  total.toString(),
                  style: AppTypoGraPhy.heading04.copyWith(
                    color: appTheme.contentColor700,
                  ),
                );
              },
            ),
          ],
        ),
        NFTLayoutViewTypeSelector(builder: (viewType) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              NFTLayoutType type = NFTLayoutType.grid;

              if(viewType == NFTLayoutType.grid){
                type = NFTLayoutType.list;
              }
              NFTBloc.of(context).add(
                NFTEventOnSwitchViewType(
                  type: type,
                ),
              );
            },
            child: _buildIcon(viewType),
          );
        }),
      ],
    );
  }

  Widget _buildIcon(
    NFTLayoutType viewType,
  ) {
    switch (viewType) {
      case NFTLayoutType.grid:
        return SvgPicture.asset(
          AssetIconPath.nftList,
        );
      case NFTLayoutType.list:
        return SvgPicture.asset(
          AssetIconPath.nftGrid,
        );
    }
  }
}
