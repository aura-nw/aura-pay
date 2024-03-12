import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class OnBoardingCreateEAOScreen extends StatefulWidget {
  const OnBoardingCreateEAOScreen({super.key});

  @override
  State<OnBoardingCreateEAOScreen> createState() =>
      _OnBoardingCreateEAOScreenState();
}

class _OnBoardingCreateEAOScreenState extends State<OnBoardingCreateEAOScreen> {
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
        return AppLocalizationProvider(
          builder: (localization, _) {
            return Scaffold(
              backgroundColor: appTheme.bodyColorBackground,
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey: LanguageKey.onBoardingCreateEoaScreenAppBarTitle,
              ),
              body: SafeArea(
                child: SizedBox(
                  width: context.w,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing05,
                      vertical: Spacing.spacing07,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: BoxSize.boxSize14,
                        ),
                        SvgPicture.asset(
                          AssetIconPath.commonLogoSmall,
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize06,
                        ),
                        Text(
                          localization.translate(
                            LanguageKey.onBoardingCreateEoaScreenCreatingNewWallet,
                          ),
                          style: AppTypoGraPhy.bodyMedium02.copyWith(
                            color: appTheme.contentColor700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize02,
                        ),
                        Text(
                          localization.translate(
                            LanguageKey.onBoardingCreateEoaScreenPleaseWait,
                          ),
                          style: AppTypoGraPhy.body01.copyWith(
                            color: appTheme.contentColor500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
