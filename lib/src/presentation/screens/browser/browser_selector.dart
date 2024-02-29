import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'browser_state.dart';

import 'browser_bloc.dart';

class BrowserAccountsSelector
    extends BlocSelector<BrowserBloc, BrowserState, List<AuraAccount>> {
  BrowserAccountsSelector({
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

class BrowserSelectedAccountSelector
    extends BlocSelector<BrowserBloc, BrowserState, AuraAccount?> {
  BrowserSelectedAccountSelector({
    Key? key,
    required Widget Function(AuraAccount?) builder,
  }) : super(
          key: key,
          selector: (state) => state.selectedAccount,
          builder: (_, selectedAccount) => builder(
            selectedAccount,
          ),
        );
}

class BrowserTabCountSelector
    extends BlocSelector<BrowserBloc, BrowserState, int> {
  BrowserTabCountSelector({
    Key? key,
    required Widget Function(int) builder,
  }) : super(
          key: key,
          selector: (state) => state.tabCount,
          builder: (_, tabCount) => builder(
            tabCount,
          ),
        );
}

class BrowserBookMarkSelector
    extends BlocSelector<BrowserBloc, BrowserState, BookMark?> {
  BrowserBookMarkSelector({
    Key? key,
    required Widget Function(BookMark?) builder,
  }) : super(
          key: key,
          selector: (state) => state.bookMark,
          builder: (_, bookMark) => builder(
            bookMark,
          ),
        );
}

class BrowserUrlSelector
    extends BlocSelector<BrowserBloc, BrowserState, String> {
  BrowserUrlSelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          key: key,
          selector: (state) => state.currentUrl,
          builder: (_, currentUrl) => builder(
            currentUrl,
          ),
        );
}

class BrowserCanGoNextSelector
    extends BlocSelector<BrowserBloc, BrowserState, bool> {
  BrowserCanGoNextSelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.canGoNext,
          builder: (_, canGoNext) => builder(
            canGoNext,
          ),
        );
}
