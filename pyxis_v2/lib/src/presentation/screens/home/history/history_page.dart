import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with StateFulBaseScreen{

  @override
  Widget child(BuildContext context, AppTheme appTheme, AppLocalizationManager localization) {
    return const Center(child:  Text("In Development"),);
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme, AppLocalizationManager localization) {
    return Scaffold( appBar: AppBarDefault(appTheme: appTheme, localization: localization, isLeftActionActive: false,title: const Text("History Page"),), body: child,);
  }
}
