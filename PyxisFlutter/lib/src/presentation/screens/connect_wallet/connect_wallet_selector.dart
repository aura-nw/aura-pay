import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connect_wallet_cubit.dart';
import 'connect_wallet_state.dart';

class ConnectWalletAccountsSelector extends BlocSelector<ConnectWalletCubit,
    ConnectWalletState, List<AuraAccount>> {
  ConnectWalletAccountsSelector({
    Key? key,
    required Widget Function(List<AuraAccount>) builder,
  }) : super(
          key: key,
          selector: (state) => state.accounts,
          builder: (_, accounts) => builder(
            accounts,
          ),
        );
}

class ConnectWalletSelectedAccountSelector extends BlocSelector<ConnectWalletCubit,
    ConnectWalletState, AuraAccount?> {
  ConnectWalletSelectedAccountSelector({
    Key? key,
    required Widget Function(AuraAccount?) builder,
  }) : super(
          key: key,
          selector: (state) => state.choosingAccount,
          builder: (_, account) => builder(
            account,
          ),
        );
}

class ConnectWalletStatusSelector extends BlocSelector<ConnectWalletCubit,
    ConnectWalletState, ConnectWalletStatus> {
  ConnectWalletStatusSelector({
    Key? key,
    required Widget Function(ConnectWalletStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(
            status,
          ),
        );
}
