import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_bloc.dart';
import 'home_page_state.dart';

/// BLoC selectors for the home page to optimize widget rebuilds.
///
/// Each selector listens to specific state properties and only rebuilds
/// when that property changes.

/// Selects the active account from home page state.
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

/// Selects the account balance from home page state.
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

/// Selects token market data (prices, changes) from home page state.
final class HomePageTokenMarketsSelector
    extends BlocSelector<HomePageBloc, HomePageState, List<TokenMarket>> {
  HomePageTokenMarketsSelector({
    super.key,
    required Widget Function(List<TokenMarket>) builder,
  }) : super(
          selector: (state) => state.tokenMarkets,
          builder: (context, tokenMarkets) => builder(tokenMarkets),
        );
}

/// Selects NFT collection from home page state.
final class HomePageNFTsSelector
    extends BlocSelector<HomePageBloc, HomePageState, List<NFTInformation>> {
  HomePageNFTsSelector({
    super.key,
    required Widget Function(List<NFTInformation>) builder,
  }) : super(
          selector: (state) => state.nftS,
          builder: (context, nftS) => builder(nftS),
        );
}

/// Selects whether token value display is enabled.
final class HomePageEnableTokenSelector
    extends BlocSelector<HomePageBloc, HomePageState, bool> {
  HomePageEnableTokenSelector({
    super.key,
    required Widget Function(bool) builder,
  }) : super(
          selector: (state) => state.enableToken,
          builder: (context, enableToken) => builder(enableToken),
        );
}

/// Selects total token value from home page state.
final class HomePageTotalTokenValueSelector
    extends BlocSelector<HomePageBloc, HomePageState, double> {
  HomePageTotalTokenValueSelector({
    super.key,
    required Widget Function(double) builder,
  }) : super(
          selector: (state) => state.totalTokenValue,
          builder: (context, totalTokenValue) => builder(totalTokenValue),
        );
}

/// Selects total portfolio value (tokens + NFTs) from home page state.
final class HomePageTotalValueSelector
    extends BlocSelector<HomePageBloc, HomePageState, double> {
  HomePageTotalValueSelector({
    super.key,
    required Widget Function(double) builder,
  }) : super(
          selector: (state) => state.totalValue,
          builder: (context, totalValue) => builder(totalValue),
        );
}

/// Selects yesterday's total value for comparison.
final class HomePageTotalValueYesterdaySelector
    extends BlocSelector<HomePageBloc, HomePageState, double> {
  HomePageTotalValueYesterdaySelector({
    super.key,
    required Widget Function(double) builder,
  }) : super(
          selector: (state) => state.totalValueYesterday,
          builder: (context, totalValueYesterday) => builder(totalValueYesterday),
        );
}

/// Selects the list of tokens from home page state.
final class HomePageTokensSelector
    extends BlocSelector<HomePageBloc, HomePageState, List<Token>> {
  HomePageTokensSelector({
    super.key,
    required Widget Function(List<Token>) builder,
  }) : super(
          selector: (state) => state.tokens,
          builder: (context, tokens) => builder(tokens),
        );
}

