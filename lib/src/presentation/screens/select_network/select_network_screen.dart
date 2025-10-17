import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:aurapay/app_configs/di.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/language_key.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/navigator.dart';
import 'widgets/network.dart';
import 'package:aurapay/src/presentation/widgets/app_bar_widget.dart';
import 'package:aurapay/src/presentation/widgets/base_screen.dart';

final class SelectNetworkScreen extends StatelessWidget
    with StatelessBaseScreen {
  final List<AppNetwork> networks = getIt.get<List<AppNetwork>>();

  SelectNetworkScreen({super.key});

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Column(
      children: [
        const Expanded(
          child: SizedBox.shrink(),
        ),
        Column(
          children: networks
              .map(
                (appNetwork) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.spacing07,
                  ),
                  child: SelectNetworkWidget(
                    appTheme: appTheme,
                    appNetwork: appNetwork,
                    onSelect: (appNetwork) {
                      AppNavigator.push(
                        RoutePath.importWallet,
                        appNetwork,
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
      ],
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
      backgroundColor: appTheme.bgPrimary,
      appBar: AppBarDefault(
        appTheme: appTheme,
        localization: localization,
        titleKey: LanguageKey.selectNetworkScreen,
      ),
      body: child,
    );
  }
}
