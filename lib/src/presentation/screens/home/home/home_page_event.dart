import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_event.freezed.dart';

@freezed
class HomePageEvent with _$HomePageEvent {
  const factory HomePageEvent.fetchTokenPrice() =
      HomePageEventOnFetchTokenPrice;

  const factory HomePageEvent.fetchTokenPriceWithAddress(String address) =
      HomePageEventOnFetchTokenPriceWithAddress;

  const factory HomePageEvent.updateCurrency({
    required List<PyxisBalance> balances,
    required double price,
  }) = HomePageEventOnUpdateCurrency;
}
