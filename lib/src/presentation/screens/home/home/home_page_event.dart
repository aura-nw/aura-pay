import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_event.freezed.dart';

@freezed
class HomePageEvent with _$HomePageEvent {
  const factory HomePageEvent.fetchTokenPrice() =
      HomePageEventOnFetchTokenPrice;

  const factory HomePageEvent.updateCurrency({
    required String balance,
    required double price,
  }) = HomePageEventOnUpdateCurrency;
}
