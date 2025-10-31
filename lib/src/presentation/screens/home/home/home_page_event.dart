import 'package:domain/core/core.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_event.freezed.dart';

/// Events for the home page BLoC.
@freezed
class HomePageEvent with _$HomePageEvent {
  /// Loads data from local storage (cached data).
  const factory HomePageEvent.getStorageData() = HomePageOnGetStorageDataEvent;

  /// Fetches fresh data from remote APIs.
  const factory HomePageEvent.getRemoteData() = HomePageOnGetRemoteDataEvent;

  /// Updates token market data (prices, changes, etc.).
  const factory HomePageEvent.updateTokenMarket({
    required List<TokenMarket> tokenMarkets,
  }) = HomePageOnUpdateTokenMarketEvent;

  /// Updates account balance for different token types.
  const factory HomePageEvent.updateAccountBalance({
    required Map<TokenType, dynamic> balanceMap,
  }) = HomePageOnUpdateAccountBalanceEvent;

  /// Updates NFT collection data.
  const factory HomePageEvent.updateNFTs({
    required List<NFTInformation> nftS,
  }) = HomePageOnUpdateNFTsEvent;

  /// Toggles the visibility of token value display.
  const factory HomePageEvent.changeEnable() =
      HomePageOnUpdateEnableTotalTokenEvent;

  /// Refreshes balance for a specific token type.
  const factory HomePageEvent.refreshTokenBalance({
    required TokenType tokenType,
  }) = HomePageOnRefreshTokenBalanceEvent;
}

