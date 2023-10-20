import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingRecoverBackupAddressScreen extends StatelessWidget {
  const OnBoardingRecoverBackupAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: NormalAppBarWidget(
            onViewMoreInformationTap: () {},
            appTheme: appTheme,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
              children: [
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return RichText(
                      text: TextSpan(
                        style: AppTypoGraPhy.heading05.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                        children: [
                          TextSpan(
                            text: localization.translate(
                              LanguageKey
                                  .onBoardingRecoverBackupAddressScreenTitleRegionOne,
                            ),
                            style: AppTypoGraPhy.heading06.copyWith(
                              color: appTheme.contentColorBrand,
                            ),
                          ),
                          TextSpan(
                            text: ' ${localization.translate(
                              LanguageKey
                                  .onBoardingRecoverBackupAddressScreenTitleRegionTwo,
                            )}',
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        LanguageKey.onBoardingRecoverBackupAddressScreenContent,
                      ),
                      style: AppTypoGraPhy.body03.copyWith(
                        color: appTheme.contentColor500,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize08,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetImagePath.onBoardingRecoverBackupAddress,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Need to fix this text after completed design
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'https://Pyxis-recoverysite.com',
                              style: AppTypoGraPhy.bodyMedium03.copyWith(
                                color: appTheme.contentColorBrand,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: BoxSize.boxSize04,
                          ),
                          GestureDetector(
                            onTap: (){

                            },
                            child: SvgPicture.asset(
                              AssetIconPath.commonCopyActive,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize03,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey
                                  .onBoardingRecoverBackupAddressScreenShareLinkTitle,
                            ),
                            style: AppTypoGraPhy.body03.copyWith(
                              color: appTheme.contentColor500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingRecoverBackupAddressScreenButtonTitle,
                      ),
                      onPress: () {
                        AppNavigator.push(RoutePath.recoverBackupDone);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
