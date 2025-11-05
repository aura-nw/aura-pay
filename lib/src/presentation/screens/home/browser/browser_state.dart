import 'package:aurapay/src/presentation/screens/home/browser/models/dapp_model.dart';

enum BrowserStatus {
  initial,
  loading,
  loaded,
  error,
}

final class BrowserState {
  final BrowserStatus status;
  final List<DAppModel> dapps;
  final List<DAppModel> filteredDapps;
  final FeaturedBannerModel? featuredBanner;
  final String searchQuery;
  final String? errorMessage;

  const BrowserState({
    this.status = BrowserStatus.initial,
    this.dapps = const [],
    this.filteredDapps = const [],
    this.featuredBanner,
    this.searchQuery = '',
    this.errorMessage,
  });

  BrowserState copyWith({
    BrowserStatus? status,
    List<DAppModel>? dapps,
    List<DAppModel>? filteredDapps,
    FeaturedBannerModel? featuredBanner,
    String? searchQuery,
    String? errorMessage,
  }) {
    return BrowserState(
      status: status ?? this.status,
      dapps: dapps ?? this.dapps,
      filteredDapps: filteredDapps ?? this.filteredDapps,
      featuredBanner: featuredBanner ?? this.featuredBanner,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

