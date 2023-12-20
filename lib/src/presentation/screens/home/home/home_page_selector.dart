import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page_bloc.dart';
import 'home_page_state.dart';

final class HomePageBalanceSelector
    extends BlocSelector<HomePageBloc, HomePageState, List<PyxisBalance>> {
  HomePageBalanceSelector({
    Key? key,
    required Widget Function(List<PyxisBalance>) builder,
  }) : super(
          key: key,
          selector: (state) => state.balances,
          builder: (_, balance) => builder(
            balance,
          ),
        );
}

final class HomePagePriceSelector
    extends BlocSelector<HomePageBloc, HomePageState, double?> {
  HomePagePriceSelector({
    Key? key,
    required Widget Function(double?) builder,
  }) : super(
          key: key,
          selector: (state) => state.price,
          builder: (_, price) => builder(
            price,
          ),
        );
}
