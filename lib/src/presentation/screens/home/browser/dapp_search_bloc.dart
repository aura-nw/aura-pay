import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurapay/src/presentation/screens/home/browser/dapp_search_event.dart';
import 'package:aurapay/src/presentation/screens/home/browser/dapp_search_state.dart';
import 'package:aurapay/src/presentation/screens/home/browser/models/dapp_model.dart';

final class DAppSearchBloc extends Bloc<DAppSearchEvent, DAppSearchState> {
  DAppSearchBloc() : super(const DAppSearchState()) {
    on<DAppSearchOnInitEvent>(_onInit);
    on<DAppSearchOnSearchEvent>(_onSearch);
    on<DAppSearchOnVisitEvent>(_onVisit);
    on<DAppSearchOnRemoveHistoryEvent>(_onRemoveHistory);
  }

  void _onInit(
    DAppSearchOnInitEvent event,
    Emitter<DAppSearchState> emit,
  ) async {
    try {
      emit(state.copyWith(status: DAppSearchStatus.loading));

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Mock data
      final trending = _getMockTrendingApps();
      final recent = _getMockRecentApps();

      emit(
        state.copyWith(
          status: DAppSearchStatus.loaded,
          trendingApps: trending,
          recentApps: recent,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DAppSearchStatus.error,
          errorMessage: 'Failed to load data',
        ),
      );
    }
  }

  void _onSearch(
    DAppSearchOnSearchEvent event,
    Emitter<DAppSearchState> emit,
  ) {
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          searchResults: [],
        ),
      );
      return;
    }

    // Combine trending and recent for search
    final allApps = [...state.trendingApps, ...state.recentApps];
    final results = allApps.where((app) {
      final nameMatch = app.name.toLowerCase().contains(query);
      final descriptionMatch = app.description.toLowerCase().contains(query);
      final urlMatch = app.url.toLowerCase().contains(query);

      return nameMatch || descriptionMatch || urlMatch;
    }).toList();

    emit(
      state.copyWith(
        searchQuery: query,
        searchResults: results,
      ),
    );
  }

  void _onVisit(
    DAppSearchOnVisitEvent event,
    Emitter<DAppSearchState> emit,
  ) {
    // Add to recent if not already there
    final recentApps = List<DAppModel>.from(state.recentApps);
    
    // Remove if exists
    recentApps.removeWhere((app) => app.id == event.dapp.id);
    
    // Add to front
    recentApps.insert(0, event.dapp);
    
    // Keep only last 10
    if (recentApps.length > 10) {
      recentApps.removeLast();
    }

    emit(
      state.copyWith(
        recentApps: recentApps,
      ),
    );

    // TODO: Navigate to DApp webview
  }

  void _onRemoveHistory(
    DAppSearchOnRemoveHistoryEvent event,
    Emitter<DAppSearchState> emit,
  ) {
    final recentApps = List<DAppModel>.from(state.recentApps);
    recentApps.removeWhere((app) => app.id == event.dappId);

    emit(
      state.copyWith(
        recentApps: recentApps,
      ),
    );
  }

  /// Mock data generators
  List<DAppModel> _getMockTrendingApps() {
    return const [
      DAppModel(
        id: 'trending_1',
        name: 'Aura Scan',
        description: 'Blockchain explorer for Aura Network',
        iconUrl: 'https://aurascan.io/favicon.ico',
        url: 'https://aurascan.io',
        isFeatured: true,
        categories: ['Explorer'],
      ),
      DAppModel(
        id: 'trending_2',
        name: 'Aura Swap',
        description: 'Decentralized exchange',
        iconUrl: 'https://auraswap.io/favicon.ico',
        url: 'https://pyxis.aura.network/',
        isFeatured: true,
        categories: ['DeFi'],
      ),
      DAppModel(
        id: 'trending_3',
        name: 'Pancake Swap',
        description: 'Leading DEX on BSC',
        iconUrl: 'https://pancakeswap.finance/favicon.ico',
        url: 'https://pancakeswap.finance',
        isFeatured: true,
        categories: ['DeFi'],
      ),
      DAppModel(
        id: 'trending_4',
        name: 'Aura',
        description: 'Aura Network ecosystem',
        iconUrl: 'https://aura.network/favicon.ico',
        url: 'https://aura.network',
        isFeatured: true,
        categories: ['Network'],
      ),
    ];
  }

  List<DAppModel> _getMockRecentApps() {
    return const [
      DAppModel(
        id: 'recent_1',
        name: 'Aura Scan',
        description: 'Blockchain explorer',
        iconUrl: 'https://aurascan.io/favicon.ico',
        url: 'https://aurascan.io/',
        categories: ['Explorer'],
      ),
      DAppModel(
        id: 'recent_2',
        name: 'Aura Swap',
        description: 'DEX platform',
        iconUrl: 'https://auraswap.io/favicon.ico',
        url: 'https://pyxis.aura.network/',
        categories: ['DeFi'],
      ),
      DAppModel(
        id: 'recent_3',
        name: 'AuraSafe',
        description: 'Multi-signature wallet',
        iconUrl: 'https://aurasafe.io/favicon.ico',
        url: 'https://auraswap.io/',
        categories: ['Security'],
      ),
    ];
  }
}

