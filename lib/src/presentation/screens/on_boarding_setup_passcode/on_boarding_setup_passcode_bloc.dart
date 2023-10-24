import 'package:flutter_bloc/flutter_bloc.dart';
import 'on_boarding_setup_passcode_event.dart';
import 'on_boarding_setup_passcode_state.dart';

class OnBoardingSetupPasscodeBloc
    extends Bloc<OnBoardingSetupPasscodeEvent, OnBoardingSetupPasscodeState> {
  OnBoardingSetupPasscodeBloc()
      : super(
          const OnBoardingSetupPasscodeState(
            status: OnBoardingSetupPasscodeStatus.init,
          ),
        );
}
