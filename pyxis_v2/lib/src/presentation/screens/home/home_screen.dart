import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_v2/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final AccountUseCase _accountUseCase = getIt.get<AccountUseCase>();
  final KeyStoreUseCase _keyStoreUseCase = getIt.get<KeyStoreUseCase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryAppButton(
          text: 'Back to get started',
          onPress: () async{
            await _accountUseCase.deleteAll();
            await _keyStoreUseCase.deleteAll();

            if(context.mounted){
              AppGlobalCubit.of(context).changeStatus(
                AppGlobalStatus.unauthorized,
              );
            }
          },
        ),
      ),
    );
  }
}
