import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    @Default([]) List<Account> accounts,
    Account? activeAccount,
    @Default([]) List<TokenMarket> tokenMarkets,
    AccountBalance ? accountBalance,
    @Default([]) List<AppNetwork> activeNetworks,
    @Default([]) List<NFTInformation> nftS,
  }) = _HomePageState;
}
