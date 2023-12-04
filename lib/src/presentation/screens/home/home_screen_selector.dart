import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen_bloc.dart';
import 'home_screen_state.dart';

class HomeScreenStatusSelector
    extends BlocSelector<HomeScreenBloc, HomeScreenState, HomeScreenStatus> {
  HomeScreenStatusSelector({
    Key? key,
    required Widget Function(HomeScreenStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(status),
        );
}

class HomeScreenAccountsSelector
    extends BlocSelector<HomeScreenBloc, HomeScreenState, List<AuraAccount>> {
  HomeScreenAccountsSelector({
    Key? key,
    required Widget Function(List<AuraAccount>) builder,
  }) : super(
          key: key,
          selector: (state) => state.accounts,
          builder: (_, accounts) => builder(accounts),
        );
}
