import 'package:aurapay/src/presentation/screens/home/browser/models/dapp_model.dart';

enum DAppSearchStatus {
  initial,
  loading,
  loaded,
  error,
}

final class DAppSearchState {
  final DAppSearchStatus status;
  final List<DAppModel> trendingApps;
  final List<DAppModel> recentApps;
  final List<DAppModel> searchResults;
  final String searchQuery;
  final String? errorMessage;

  const DAppSearchState({
    this.status = DAppSearchStatus.initial,
    this.trendingApps = const [],
    this.recentApps = const [],
    this.searchResults = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  DAppSearchState copyWith({
    DAppSearchStatus? status,
    List<DAppModel>? trendingApps,
    List<DAppModel>? recentApps,
    List<DAppModel>? searchResults,
    String? searchQuery,
    String? errorMessage,
  }) {
    return DAppSearchState(
      status: status ?? this.status,
      trendingApps: trendingApps ?? this.trendingApps,
      recentApps: recentApps ?? this.recentApps,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

