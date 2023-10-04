import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _cubit.starting();
    });
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
                case SplashScreenStatus.loadWalletSuccess:
                  AppGlobalCubit.of(context).changeState(
                    const AppGlobalState(
                      status: AppGlobalStatus.authorized,
                    ),
                  );
                  AppNavigator.replaceWith(RoutePath.home);
                  break;
                case SplashScreenStatus.loadWalletNull:
                  AppNavigator.replaceWith(RoutePath.setupWallet);
                  break;
              }
            },
            child: const Scaffold(
              body: Center(
                child: Image(
                  image: AssetImage(
                    AssetImagePath.logo,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
