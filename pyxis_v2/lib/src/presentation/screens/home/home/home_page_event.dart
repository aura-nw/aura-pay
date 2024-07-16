import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_event.freezed.dart';

@freezed
class HomePageEvent with _$HomePageEvent {
  const factory HomePageEvent.getStorageData() = HomePageOnGetStorageDataEvent;

  const factory HomePageEvent.getRemoteData() = HomePageOnGetRemoteDataEvent;

  const factory HomePageEvent.updateTokenMarket({
    required List<TokenMarket> tokenMarkets,
  }) = HomePageOnUpdateTokenMarketEvent;

  const factory HomePageEvent.updateAccountBalance({
    required Map<AppNetworkType,String> balanceMap,
  }) = HomePageOnUpdateAccountBalanceEvent;
}
