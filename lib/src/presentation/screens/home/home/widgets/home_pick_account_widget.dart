import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';

abstract interface class _HomeAccountItemWidget extends StatelessWidget{
  Widget accountInformationBuilder(BuildContext context,AppTheme appTheme);

  Widget actionBuilder(BuildContext context,AppTheme appTheme);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [

      ],
    );
  }
}

class HomePickAccountWidget extends StatelessWidget {
  const HomePickAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [

      ],
    );
  }
}
