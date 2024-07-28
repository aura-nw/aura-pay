import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/network.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/navigator.dart';
import 'widgets/network.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

final class SelectNetworkScreen extends StatelessWidget
    with StatelessBaseScreen {
  late final List<AppNetwork> networks;

  SelectNetworkScreen({super.key}) {
    final config = getIt.get<PyxisMobileConfig>();

    networks = createNetwork(config);
  }

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
