import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with StateFulBaseScreen{

   @override
  Widget child(BuildContext context, AppTheme appTheme, AppLocalizationManager localization) {
    return const Center(child: const Text("In Development"),);
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme, AppLocalizationManager localization) {
    return Scaffold( appBar: AppBarDefault(appTheme: appTheme, localization: localization, isLeftActionActive: false,title: const Text("Wallet Page"),), body: child,);
  }
}
