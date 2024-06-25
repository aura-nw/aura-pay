import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_state.freezed.dart';

@freezed
class HomePageState with _$HomePageState {
  const factory HomePageState({
    @Default([]) List<PyxisBalance> balances,
    double ?price,
    @Default(false) bool hideTokenValue,
  }) = _HomePageState;
}
