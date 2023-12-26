import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/nft_selector.dart';
import 'package:pyxis_mobile/src/presentation/screens/nft/widgets/nft_vertical_card.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combined_gridview.dart';
import 'nft_horizontal_card.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';

class NFTLayoutBuilder extends StatelessWidget {
  final AppTheme appTheme;

  const NFTLayoutBuilder({
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NFTLayoutViewTypeSelector(
      builder: (viewType) {
        return NFTInformationSSelector(builder: (nFTs) {
          if (nFTs.isEmpty) {
            return Center(
              child: AppLocalizationProvider(
                builder: (localization, _) {
                  return Text(
                    localization.translate(
                      LanguageKey.nftScreenNoNFTFound,
                    ),
                    style: AppTypoGraPhy.bodyMedium02.copyWith(
                      color: appTheme.contentColor500,
                    ),
                  );
                },
              ),
            );
          }
          return NFTCanLoadMoreSelector(builder: (canLoadMore) {
            return _buildLayout(
              viewType,
              context,
              nFTs,
              canLoadMore,
            );
          });
        });
      },
    );
  }

  Widget _buildLayout(
    NFTLayoutType nftLayoutType,
    BuildContext context,
    List<NFTInformation> nFTs,
    bool canLoadMore,
  ) {
    switch (nftLayoutType) {
      case NFTLayoutType.grid:
        return CombinedGridView(
          childCount: 2,
          onRefresh: () {
            _onRefresh(context);
          },
          onLoadMore: () {
            if (canLoadMore) {
              _onLoadMore(context);
            }
          },
          data: nFTs,
          builder: (nft, index) {
            return NFTVerticalCard(
              name: nft.cw721Contract.name,
              url: nft.mediaInfo.offChain.image.url ?? '',
              appTheme: appTheme,
              idToken: '#${nft.tokenId}',
            );
          },
          canLoadMore: canLoadMore,
          childAspectRatio: 1.2,
          crossAxisSpacing: Spacing.spacing06,
          mainAxisSpacing: Spacing.spacing07,
        );
      case NFTLayoutType.list:
        return CombinedListView(
          onRefresh: () {
            _onRefresh(context);
          },
          onLoadMore: () {
            if (canLoadMore) {
              _onLoadMore(context);
            }
          },
          data: nFTs,
          builder: (nft, index) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: Spacing.spacing05,
              ),
              child: NFTHorizontalCard(
                name: nft.cw721Contract.name,
                url: nft.mediaInfo.offChain.image.url ?? '',
                createAt: nft.createdAt.toString(),
                appTheme: appTheme,
                idToken: '#${nft.tokenId}',
              ),
            );
          },
          canLoadMore: canLoadMore,
        );
    }
  }

  void _onLoadMore(
    BuildContext context,
  ) {
    NFTBloc.of(context).add(
      const NFTEventOnLoadMore(),
    );
  }

  void _onRefresh(
    BuildContext context,
  ) {
    NFTBloc.of(context).add(
      const NFTEventOnRefresh(),
    );
  }
}
