import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class OnBoardingCreateEAOByGoogleScreen extends StatefulWidget {
  const OnBoardingCreateEAOByGoogleScreen({super.key});

  @override
  State<OnBoardingCreateEAOByGoogleScreen> createState() =>
      _OnBoardingCreateEAOByGoogleScreenState();
}

class _OnBoardingCreateEAOByGoogleScreenState
    extends State<OnBoardingCreateEAOByGoogleScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(
        const Duration(
          seconds: 2,
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey: '',
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing05,
                vertical: Spacing.spacing07,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetLogoPath.logo,
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize06,
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          '',
                        ),
                        style: AppTypoGraPhy.bodyMedium02.copyWith(
                          color: appTheme.contentColor700,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize03,
                  ),
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          '',
                        ),
                        style: AppTypoGraPhy.body01.copyWith(
                          color: appTheme.contentColor500,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
