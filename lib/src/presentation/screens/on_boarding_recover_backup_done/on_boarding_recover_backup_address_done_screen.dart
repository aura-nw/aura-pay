import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/label_input_widget.dart';

class OnBoardingRecoverBackupDoneAddressScreen extends StatelessWidget {
  const OnBoardingRecoverBackupDoneAddressScreen({super.key});

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        .onBoardingRecoverBackupAddressDoneScreenTitleRegionOne,
                                  ),
                                  style: AppTypoGraPhy.heading06.copyWith(
                                    color: appTheme.contentColorBrand,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${localization.translate(
                                    LanguageKey
                                        .onBoardingRecoverBackupAddressDoneScreenTitleRegionTwo,
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
                          return LabelInputWidget(
                            theme: appTheme,
                            label: localization.translate(
                              LanguageKey
                                  .onBoardingRecoverBackupAddressDoneScreenPublicKeyLabel,
                            ),
                            /// Need to fix this text after completed design
                            value: '0x04345f1aasdasdasd55sdf4sdf5sdfs2d1f0349e803fdbbe3',
                            iconPath: AssetIconPath.commonCopy,
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize05,
                      ),
                      const HoLiZonTalDividerWidget(
                        height: BoxSize.boxSize01,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize03,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey
                                  .onBoardingRecoverBackupAddressDoneScreenContent,
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
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingRecoverBackupAddressDoneScreenButtonCopyTitle,
                      ),
                      onPress: () {},
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize05,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return TextAppButton(
                      text: localization.translate(
                        LanguageKey
                            .onBoardingRecoverBackupAddressDoneScreenButtonDoneTitle,
                      ),
                      onPress: () {},
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
