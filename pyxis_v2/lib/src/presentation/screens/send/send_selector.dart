import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'send_bloc.dart';
import 'send_state.dart';

final class SendStatusSelector
    extends BlocSelector<SendBloc, SendState, SendStatus> {
  SendStatusSelector({
    super.key,
    required Widget Function(SendStatus) builder,
  }) : super(
          selector: (state) => state.status,
          builder: (context, status) => builder(status),
        );
}

final class SendFromSelector
    extends BlocSelector<SendBloc, SendState, Account?> {
  SendFromSelector({
    super.key,
    required Widget Function(Account?) builder,
  }) : super(
          selector: (state) => state.account,
          builder: (context, account) => builder(account),
        );
}

final class SendAlreadySelector
    extends BlocSelector<SendBloc, SendState, bool> {
  SendAlreadySelector({
    super.key,
    required Widget Function(bool) builder,
  }) : super(
          selector: (state) => state.already,
          builder: (context, already) => builder(already),
        );
}

final class SendIsSavedSelector
    extends BlocSelector<SendBloc, SendState, bool> {
  SendIsSavedSelector({
    super.key,
    required Widget Function(bool) builder,
  }) : super(
          selector: (state) => state.isSaved,
          builder: (context, isSaved) => builder(isSaved),
        );
}

final class SendAccountBalanceSelector
    extends BlocSelector<SendBloc, SendState, AccountBalance?> {
  SendAccountBalanceSelector({
    super.key,
    required Widget Function(AccountBalance?) builder,
  }) : super(
          selector: (state) => state.accountBalance,
          builder: (context, accountBalance) => builder(accountBalance),
        );
}

final class SendAppNetworksSelector
    extends BlocSelector<SendBloc, SendState, List<AppNetwork>> {
  SendAppNetworksSelector({
    super.key,
    required Widget Function(List<AppNetwork>) builder,
  }) : super(
          selector: (state) => state.appNetworks,
          builder: (context, appNetworks) => builder(appNetworks),
        );
}

final class SendSelectedNetworkSelector
    extends BlocSelector<SendBloc, SendState, AppNetwork> {
  SendSelectedNetworkSelector({
    super.key,
    required Widget Function(AppNetwork) builder,
  }) : super(
          selector: (state) => state.selectedNetwork,
          builder: (context, selectedNetwork) => builder(selectedNetwork),
        );
}
