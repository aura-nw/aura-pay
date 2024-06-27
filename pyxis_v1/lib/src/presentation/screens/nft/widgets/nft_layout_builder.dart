import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
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
        return NFTInformationSSelector(
          builder: (nFTs) {
            if (nFTs.isEmpty) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: () async => _onRefresh(context),
                  ),
                  SliverFillRemaining(
                    child: Center(
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
                    ),
                  ),
                ],
              );
            }
            return NFTCanLoadMoreSelector(
              builder: (canLoadMore) {
                return AnimatedCrossFade(
                  duration: const Duration(
                    milliseconds: 700,
                  ),
                  crossFadeState: viewType == NFTLayoutType.grid
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  secondChild: _buildListView(
                    context,
                    nFTs,
                    canLoadMore,
                  ),
                  firstChild: _buildGridView(
                    context,
                    nFTs,
                    canLoadMore,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List<NFTInformation> nFTs,
    bool canLoadMore,
  ) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: CombinedGridView(
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
          return GestureDetector(
            onTap: () {
              AppNavigator.push(
                RoutePath.nftDetail,
                nft,
              );
            },
            behavior: HitTestBehavior.opaque,
            child: NFTVerticalCard(
              name: nft.cw721Contract.name,
              url: nft.mediaInfo.offChain.image.url ?? '',
              appTheme: appTheme,
              idToken: '#${nft.tokenId}',
              key: ValueKey(nft),
            ),
          );
        },
        canLoadMore: canLoadMore,
        childAspectRatio: 1.2,
        crossAxisSpacing: Spacing.spacing06,
        mainAxisSpacing: Spacing.spacing07,
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<NFTInformation> nFTs,
    bool canLoadMore,
  ) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: CombinedListView(
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
            child: GestureDetector(
              onTap: () {
                AppNavigator.push(
                  RoutePath.nftDetail,
                  nft,
                );
              },
              behavior: HitTestBehavior.opaque,
              child: NFTHorizontalCard(
                name: nft.cw721Contract.name,
                url: nft.mediaInfo.offChain.image.url ?? '',
                appTheme: appTheme,
                idToken: '#${nft.tokenId}',
                key: ValueKey(nft),
              ),
            ),
          );
        },
        canLoadMore: canLoadMore,
      ),
    );
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
