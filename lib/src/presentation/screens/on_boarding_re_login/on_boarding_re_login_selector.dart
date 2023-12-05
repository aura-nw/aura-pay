import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_re_login/on_boarding_re_login_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_re_login/on_boarding_re_login_state.dart';

final class OnBoardingReLoginStatusSelector extends BlocSelector<
    OnBoardingReLoginBloc, OnBoardingReLoginState, OnBoardingReLoginStatus> {
  OnBoardingReLoginStatusSelector({
    Key? key,
    required Widget Function(OnBoardingReLoginStatus) builder,
  }) : super(
          key: key,
          selector: (state) => state.status,
          builder: (_, status) => builder(
            status,
          ),
        );
}