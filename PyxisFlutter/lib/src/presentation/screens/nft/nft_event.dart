import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';

part 'nft_event.freezed.dart';

@freezed
class NFTEvent with _$NFTEvent {
  const factory NFTEvent.onInit() = NFTEventOnInit;

  const factory NFTEvent.onLoadMore() = NFTEventOnLoadMore;

  const factory NFTEvent.onRefresh() = NFTEventOnRefresh;

  const factory NFTEvent.onSwitchType({
    required NFTLayoutType type,
  }) = NFTEventOnSwitchViewType;
}
