import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_global_state.freezed.dart';

enum AppGlobalStatus {
  unauthorized,
  authorized,
}

class GlobalActiveAccount {
  final String accountName;
  final String address;

  const GlobalActiveAccount({
    required this.address,
    required this.accountName,
  });
}

@freezed
class AppGlobalState with _$AppGlobalState {
  const factory AppGlobalState({
    @Default(AppGlobalStatus.unauthorized) AppGlobalStatus status,
    @Default([]) List<GlobalActiveAccount> accounts,
  }) = _AppGlobalState;
}
