import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

part 'connect_site_state.freezed.dart';

enum ConnectSiteStatus {
  loading,
  loaded,
}

@freezed
class ConnectSiteState with _$ConnectSiteState {
  const factory ConnectSiteState({
    @Default(ConnectSiteStatus.loading) ConnectSiteStatus status,
    @Default([]) List<SessionData> sessions,
    @Default([]) List<AuraAccount> accounts,
  }) = _ConnectSiteState;
}
