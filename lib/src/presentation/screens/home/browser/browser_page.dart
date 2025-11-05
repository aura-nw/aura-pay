import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';
import 'package:aurapay/src/presentation/widgets/base_screen.dart';
import 'browser_bloc.dart';
import 'browser_event.dart';
import 'browser_state.dart';
import 'models/dapp_model.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> with StateFulBaseScreen {
  late BrowserBloc _bloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = BrowserBloc();
    _bloc.add(const BrowserOnInitEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state.status == BrowserStatus.loading) {
          return Center(
            child: CircularProgressIndicator(
              color: appTheme.fgBrandPrimary,
            ),
          );
        }

        if (state.status == BrowserStatus.error) {
          return Center(
            child: Text(
              state.errorMessage ??
                  localization.translate('browser_page_error_occurred'),
              style: AppTypoGraPhy.textMdRegular.copyWith(
                color: appTheme.textErrorPrimary,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            _bloc.add(const BrowserOnRefreshEvent());
            await Future.delayed(const Duration(milliseconds: 600));
          },
          color: appTheme.fgBrandPrimary,
          child: CustomScrollView(
            slivers: [
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.spacing05),
                  child: _buildSearchBar(appTheme, localization),
                ),
              ),

              // Featured banner
              if (state.featuredBanner != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing05,
                    ),
                    child: _buildFeaturedBanner(
                      state.featuredBanner!,
                      appTheme,
                      localization,
                    ),
                  ),
                ),

              // Popular DApps header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.spacing05),
                  child: Text(
                    localization.translate('browser_page_popular_dapps'),
                    style: AppTypoGraPhy.textLgSemiBold.copyWith(
                      color: appTheme.textPrimary,
                    ),
                  ),
                ),
              ),

              // DApps list
              if (state.filteredDapps.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      localization.translate('browser_page_no_dapps'),
                      style: AppTypoGraPhy.textMdRegular.copyWith(
                        color: appTheme.textTertiary,
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final dapp = state.filteredDapps[index];
                      return _buildDAppItem(
                        dapp,
                        appTheme,
                        localization,
                      );
                    },
                    childCount: state.filteredDapps.length,
                  ),
                ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: Spacing.spacing07),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(
      AppTheme appTheme, AppLocalizationManager localization) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: appTheme.bgSecondary,
        borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius03),
      ),
      child: TextField(
        controller: _searchController,
        style: AppTypoGraPhy.textMdRegular.copyWith(
          color: appTheme.textPrimary,
        ),
        textAlignVertical: TextAlignVertical.center,
        onChanged: (value) {
          _bloc.add(BrowserOnSearchEvent(value));
        },
        decoration: InputDecoration(
          hintText: localization.translate('browser_page_search_hint'),
          hintStyle: AppTypoGraPhy.textMdRegular.copyWith(
            color: appTheme.textPlaceholder,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(Spacing.spacing04),
            child: SvgPicture.asset(
              'assets/icon/ic_common_search.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                appTheme.fgQuaternary,
                BlendMode.srcIn,
              ),
            ),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Spacing.spacing04,
            vertical: Spacing.spacing04,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedBanner(
    FeaturedBannerModel banner,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            appTheme.bgBrandSecondary,
            appTheme.bgBrandPrimary,
          ],
        ),
        borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius04),
      ),
      child: Stack(
        children: [
          // Illustration placeholder (you can add custom illustration here)
          Positioned(
            right: -20,
            top: 20,
            bottom: 20,
            child: Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.currency_bitcoin,
                size: 120,
                color: appTheme.fgWhite,
              ),
            ),
          ),

          // Text content
          Positioned(
            left: Spacing.spacing05,
            bottom: Spacing.spacing05,
            right: Spacing.spacing05,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  banner.title,
                  style: AppTypoGraPhy.textXlBold.copyWith(
                    color: appTheme.textWhite,
                  ),
                ),
                const SizedBox(height: Spacing.spacing02),
                Text(
                  banner.subtitle,
                  style: AppTypoGraPhy.textSmRegular.copyWith(
                    color: appTheme.textWhite.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDAppItem(
    DAppModel dapp,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing05,
        vertical: Spacing.spacing02,
      ),
      padding: const EdgeInsets.all(Spacing.spacing04),
      decoration: BoxDecoration(
        color: appTheme.bgPrimary,
        borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius03),
        border: Border.all(
          color: appTheme.borderSecondary,
          width: BorderSize.border01,
        ),
      ),
      child: Row(
        children: [
          // DApp Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: appTheme.bgSecondary,
              borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius03),
            ),
            child: Center(
              child: _buildDAppIcon(dapp, appTheme),
            ),
          ),
          const SizedBox(width: Spacing.spacing04),

          // DApp Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dapp.name,
                  style: AppTypoGraPhy.textMdSemiBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.spacing01),
                Text(
                  dapp.description,
                  style: AppTypoGraPhy.textSmRegular.copyWith(
                    color: appTheme.textTertiary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.spacing04),

          // Visit Button
          InkWell(
            onTap: () {
              _bloc.add(BrowserOnVisitDAppEvent(dapp.id, dapp.url));
              // TODO: Navigate to webview or external browser
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing04,
                vertical: Spacing.spacing02,
              ),
              decoration: BoxDecoration(
                color: appTheme.bgBrandPrimary,
                borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius02),
              ),
              child: Text(
                localization.translate('browser_page_visit'),
                style: AppTypoGraPhy.textSmSemiBold.copyWith(
                  color: appTheme.textWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDAppIcon(DAppModel dapp, AppTheme appTheme) {
    // Mock icons based on DApp name
    IconData iconData;
    Color iconColor;

    switch (dapp.name) {
      case 'Aura Scan':
        iconData = Icons.search;
        iconColor = appTheme.fgBrandPrimary;
        break;
      case 'Aura Swap':
        iconData = Icons.swap_horiz;
        iconColor = const Color(0xFF4CAF50);
        break;
      case 'AuraSafe':
        iconData = Icons.security;
        iconColor = const Color(0xFF2196F3);
        break;
      default:
        iconData = Icons.apps;
        iconColor = appTheme.fgTertiary;
    }

    return Icon(
      iconData,
      size: 28,
      color: iconColor,
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
      backgroundColor: appTheme.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Custom app bar
            Padding(
              padding: const EdgeInsets.all(Spacing.spacing05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  localization.translate('browser_page_title'),
                  style: AppTypoGraPhy.displayXsSemiBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
