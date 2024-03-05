import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connect_wallet_state.freezed.dart';

enum ConnectWalletStatus {
  loading,
  loaded,
}

@freezed
class ConnectWalletState with _$ConnectWalletState {
  const factory ConnectWalletState({
    @Default(ConnectWalletStatus.loading) ConnectWalletStatus status,
    @Default([]) List<AuraAccount> accounts,
    AuraAccount? choosingAccount,
  }) = _ConnectWalletState;
}
