import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_bloc.dart';
import 'home_page_state.dart';

final class HomePageAccountsSelector
    extends BlocSelector<HomePageBloc, HomePageState, List<Account>> {
  HomePageAccountsSelector({
    super.key,
    required Widget Function(List<Account>) builder,
  }) : super(
          selector: (state) => state.accounts,
          builder: (context, accounts) => builder(accounts),
        );
}

final class HomePageActiveAccountSelector
    extends BlocSelector<HomePageBloc, HomePageState, Account?> {
  HomePageActiveAccountSelector({
    super.key,
    required Widget Function(Account?) builder,
  }) : super(
          selector: (state) => state.activeAccount,
          builder: (context, activeAccount) => builder(activeAccount),
        );
}

final class HomePageAccountBalanceSelector
    extends BlocSelector<HomePageBloc, HomePageState, AccountBalance?> {
  HomePageAccountBalanceSelector({
    super.key,
    required Widget Function(AccountBalance?) builder,
  }) : super(
          selector: (state) => state.accountBalance,
          builder: (context, accountBalance) => builder(accountBalance),
        );
}

final class HomePageNetworksSelector
    extends BlocSelector<HomePageBloc, HomePageState, List<AppNetwork>> {
  HomePageNetworksSelector({
    super.key,
    required Widget Function(List<AppNetwork>) builder,
  }) : super(
          selector: (state) => state.networks,
          builder: (context, networks) => builder(networks),
        );
}

final class HomePageAuraMarketSelector
    extends BlocSelector<HomePageBloc, HomePageState, TokenMarket?> {
  HomePageAuraMarketSelector({
    super.key,
    required Widget Function(TokenMarket?) builder,
  }) : super(
          selector: (state) => state.auraMarket,
          builder: (context, auraMarket) => builder(auraMarket),
        );
}
