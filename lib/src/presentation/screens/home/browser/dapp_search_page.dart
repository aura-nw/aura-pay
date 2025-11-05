import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';
import 'package:aurapay/src/core/helpers/app_launcher.dart';
import 'package:aurapay/src/presentation/widgets/base_screen.dart';
import 'package:aurapay/src/navigator.dart';
import 'dapp_search_bloc.dart';
import 'dapp_search_event.dart';
import 'dapp_search_state.dart';
import 'models/dapp_model.dart';

class DAppSearchPage extends StatefulWidget {
  const DAppSearchPage({super.key});

  @override
  State<DAppSearchPage> createState() => _DAppSearchPageState();
}

class _DAppSearchPageState extends State<DAppSearchPage>
    with StateFulBaseScreen {
  late DAppSearchBloc _bloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = DAppSearchBloc();
    _bloc.add(const DAppSearchOnInitEvent());
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
    return BlocBuilder<DAppSearchBloc, DAppSearchState>(
      bloc: _bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar section
            _buildSearchBar(appTheme, localization),
            const SizedBox(height: Spacing.spacing05),

            // Trending Apps section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing05),
              child: Text(
                localization.translate('dapp_search_trending_apps'),
                style: AppTypoGraPhy.textLgSemiBold.copyWith(
                  color: appTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.spacing04),

            // Trending apps grid
            _buildTrendingApps(state, appTheme, localization),
            const SizedBox(height: Spacing.spacing06),

            // Recent section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing05),
              child: Text(
                localization.translate('dapp_search_recent'),
                style: AppTypoGraPhy.textLgSemiBold.copyWith(
                  color: appTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: Spacing.spacing04),

            // Recent list
            Expanded(
              child: _buildRecentList(state, appTheme, localization),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(
      AppTheme appTheme, AppLocalizationManager localization) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing05),
      child: Container(
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
            _bloc.add(DAppSearchOnSearchEvent(value));
          },
          decoration: InputDecoration(
            hintText: localization.translate('dapp_search_hint'),
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
      ),
    );
  }

  Widget _buildTrendingApps(
    DAppSearchState state,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing05),
        itemCount: state.trendingApps.length,
        itemBuilder: (context, index) {
          final app = state.trendingApps[index];
          return _buildTrendingAppItem(app, appTheme, localization);
        },
      ),
    );
  }

  Widget _buildTrendingAppItem(
    DAppModel app,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return InkWell(
      onTap: () async {
        _bloc.add(DAppSearchOnVisitEvent(app));
        // Open URL in external browser
        await AppLauncher.launch(app.url);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: Spacing.spacing04),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with gradient background
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(app.name),
                ),
                borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius04),
              ),
              child: Center(
                child: _buildTrendingAppIcon(app, appTheme),
              ),
            ),
            const SizedBox(height: Spacing.spacing02),
            // Name
            Text(
              app.name,
              style: AppTypoGraPhy.textXsRegular.copyWith(
                color: appTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingAppIcon(DAppModel app, AppTheme appTheme) {
    IconData iconData;
    switch (app.name) {
      case 'Aura Scan':
        iconData = Icons.camera_alt_outlined;
        break;
      case 'Aura Swap':
        iconData = Icons.swap_horiz;
        break;
      case 'Pancake Swap':
        iconData = Icons.cake;
        break;
      case 'Aura':
        iconData = Icons.waves;
        break;
      default:
        iconData = Icons.apps;
    }

    return Icon(
      iconData,
      size: 32,
      color: Colors.white,
    );
  }

  List<Color> _getGradientColors(String appName) {
    switch (appName) {
      case 'Aura Scan':
        return [const Color(0xFF6DD5FA), const Color(0xFF2980B9)];
      case 'Aura Swap':
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
      case 'Pancake Swap':
        return [const Color(0xFFF093FB), const Color(0xFFF5576C)];
      case 'Aura':
        return [const Color(0xFF4FACFE), const Color(0xFF00F2FE)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }

  Widget _buildRecentList(
    DAppSearchState state,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    if (state.recentApps.isEmpty) {
      return Center(
        child: Text(
          localization.translate('dapp_search_no_recent'),
          style: AppTypoGraPhy.textMdRegular.copyWith(
            color: appTheme.textTertiary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.spacing05),
      itemCount: state.recentApps.length,
      separatorBuilder: (context, index) => const SizedBox(height: Spacing.spacing03),
      itemBuilder: (context, index) {
        final app = state.recentApps[index];
        return _buildRecentItem(app, appTheme, localization);
      },
    );
  }

  Widget _buildRecentItem(
    DAppModel app,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) {
    return InkWell(
      onTap: () async {
        _bloc.add(DAppSearchOnVisitEvent(app));
        // Open URL in external browser
        await AppLauncher.launch(app.url);
      },
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: appTheme.bgSecondary,
              borderRadius: BorderRadius.circular(BorderRadiusSize.borderRadius03),
            ),
            child: Center(
              child: _buildRecentAppIcon(app, appTheme),
            ),
          ),
          const SizedBox(width: Spacing.spacing04),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: AppTypoGraPhy.textMdSemiBold.copyWith(
                    color: appTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.spacing01),
                Text(
                  app.url,
                  style: AppTypoGraPhy.textSmRegular.copyWith(
                    color: appTheme.textTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Remove button
          InkWell(
            onTap: () {
              _bloc.add(DAppSearchOnRemoveHistoryEvent(app.id));
            },
            child: Padding(
              padding: const EdgeInsets.all(Spacing.spacing02),
              child: Icon(
                Icons.close,
                size: 20,
                color: appTheme.fgTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAppIcon(DAppModel app, AppTheme appTheme) {
    IconData iconData;
    Color iconColor;

    switch (app.name) {
      case 'Aura Scan':
        iconData = Icons.search;
        iconColor = const Color(0xFF2980B9);
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
      size: 24,
      color: iconColor,
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
      backgroundColor: appTheme.bgPrimary,
      appBar: AppBar(
        backgroundColor: appTheme.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: appTheme.fgPrimary,
          ),
          onPressed: () {
            AppNavigator.pop();
          },
        ),
        title: Text(
          localization.translate('dapp_search_title'),
          style: AppTypoGraPhy.textLgSemiBold.copyWith(
            color: appTheme.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: child,
      ),
    );
  }
}

