import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'splash_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_screen_cubit.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashScreenCubit _cubit = getIt.get<SplashScreenCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.starting();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (theme) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocListener<SplashScreenCubit, SplashScreenState>(
            bloc: _cubit,
            listener: (context, state) {
              switch (state.status) {
                case SplashScreenStatus.starting:
                  break;
                case SplashScreenStatus.verifyByBioSuccessful:
                  AppGlobalCubit.of(context).changeState(
                    const AppGlobalState(
                      status: AppGlobalStatus.authorized,
                    ),
                  );
                  break;
                case SplashScreenStatus.hasPassCode:
                  AppNavigator.replaceWith(
                    RoutePath.reLogin,
                  );
                  break;
                case SplashScreenStatus.notHasPassCodeOrError:
                  AppNavigator.replaceWith(
                    RoutePath.getStarted,
                  );
                  break;
              }
            },
            child: Scaffold(
              body: SvgPicture.asset(
                AssetImagePath.splashScreen,
                fit: BoxFit.cover,
                width: context.w,
                height: context.h,
              ),
            ),
          ),
        );
      },
    );
  }
}
