import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_screen_event.freezed.dart';

@freezed
class HomeScreenEvent with _$HomeScreenEvent{
  const factory HomeScreenEvent.init() = HomeScreenEventOnInit;
  const factory HomeScreenEvent.reFetchAccount() = HomeScreenEventOnReFetchAccount;
  const factory HomeScreenEvent.onRenameAccountEvent(int id,String name) = HomeScreenEventOnRenameAccount;
  const factory HomeScreenEvent.onRemoveAccount(int id,String address,) = HomeScreenEventOnRemoveAccount;
}