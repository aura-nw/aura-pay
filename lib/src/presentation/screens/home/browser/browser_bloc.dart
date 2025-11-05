import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurapay/src/presentation/screens/home/browser/browser_event.dart';
import 'package:aurapay/src/presentation/screens/home/browser/browser_state.dart';
import 'package:aurapay/src/presentation/screens/home/browser/models/dapp_model.dart';

final class BrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  BrowserBloc() : super(const BrowserState()) {
    on<BrowserOnInitEvent>(_onInit);
    on<BrowserOnSearchEvent>(_onSearch);
    on<BrowserOnVisitDAppEvent>(_onVisitDApp);
    on<BrowserOnRefreshEvent>(_onRefresh);
  }

  void _onInit(
    BrowserOnInitEvent event,
    Emitter<BrowserState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BrowserStatus.loading));

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace this with actual API call
      final dapps = _getMockDApps();
      final featuredBanner = _getMockFeaturedBanner();

      emit(
        state.copyWith(
          status: BrowserStatus.loaded,
          dapps: dapps,
          filteredDapps: dapps,
          featuredBanner: featuredBanner,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BrowserStatus.error,
          errorMessage: 'Failed to load DApps',
        ),
      );
    }
  }

  void _onSearch(
    BrowserOnSearchEvent event,
    Emitter<BrowserState> emit,
  ) {
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          filteredDapps: state.dapps,
        ),
      );
      return;
    }

    final filtered = state.dapps.where((dapp) {
      final nameMatch = dapp.name.toLowerCase().contains(query);
      final descriptionMatch = dapp.description.toLowerCase().contains(query);
      final categoriesMatch = dapp.categories.any(
        (category) => category.toLowerCase().contains(query),
      );

      return nameMatch || descriptionMatch || categoriesMatch;
    }).toList();

    emit(
      state.copyWith(
        searchQuery: query,
        filteredDapps: filtered,
      ),
    );
  }

  void _onVisitDApp(
    BrowserOnVisitDAppEvent event,
    Emitter<BrowserState> emit,
  ) {
    // TODO: Implement navigation to DApp webview or external browser
    // This would typically involve:
    // 1. Logging analytics
    // 2. Opening a WebView or external browser
    // 3. Tracking user interaction
  }

  void _onRefresh(
    BrowserOnRefreshEvent event,
    Emitter<BrowserState> emit,
  ) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace this with actual API call
      final dapps = _getMockDApps();
      final featuredBanner = _getMockFeaturedBanner();

      emit(
        state.copyWith(
          status: BrowserStatus.loaded,
          dapps: dapps,
          filteredDapps: state.searchQuery.isEmpty
              ? dapps
              : dapps.where((dapp) {
                  final query = state.searchQuery.toLowerCase();
                  return dapp.name.toLowerCase().contains(query) ||
                      dapp.description.toLowerCase().contains(query) ||
                      dapp.categories.any(
                        (category) => category.toLowerCase().contains(query),
                      );
                }).toList(),
          featuredBanner: featuredBanner,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BrowserStatus.error,
          errorMessage: 'Failed to refresh DApps',
        ),
      );
    }
  }

  /// Mock data generator - replace with actual API call
  List<DAppModel> _getMockDApps() {
    return const [
      DAppModel(
        id: '1',
        name: 'Aura Scan',
        description: 'The next generation blockchain explorer for Aura Network',
        iconUrl: 'https://aurascan.io/favicon.ico',
        url: 'https://aurascan.io',
        isFeatured: true,
        categories: ['Explorer', 'Tools'],
      ),
      DAppModel(
        id: '2',
        name: 'Aura Swap',
        description:
            'Swap, earn, and bridge real-world assets with secure, compliant infrastructure',
        iconUrl: 'https://auraswap.io/favicon.ico',
        url: 'https://auraswap.io',
        isFeatured: true,
        categories: ['DeFi', 'Swap'],
      ),
      DAppModel(
        id: '3',
        name: 'AuraSafe',
        description:
            'Multi-signature and finegrain access control, asset management tool',
        iconUrl: 'https://aurasafe.io/favicon.ico',
        url: 'https://aurasafe.io',
        isFeatured: true,
        categories: ['Security', 'Wallet'],
      ),
    ];
  }

  FeaturedBannerModel _getMockFeaturedBanner() {
    return const FeaturedBannerModel(
      id: '1',
      title: 'Yield Farming Secrets',
      subtitle: 'Maximize your returns with top DeFi protocols.',
      actionUrl: 'https://defi.aurapay.io',
    );
  }
}

