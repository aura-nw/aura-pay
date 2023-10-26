import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'widgets/input_password_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/key_board_number_widget.dart';

class ReLoginScreen extends StatefulWidget {
  const ReLoginScreen({super.key});

  @override
  State<ReLoginScreen> createState() => _ReLoginScreenState();
}

class _ReLoginScreenState extends State<ReLoginScreen> {

  int _fillIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AssetLogoPath.logo,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize05,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey.reLoginScreenTitle,
                            ),
                            style: AppTypoGraPhy.heading04.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize08,
                      ),
                      InputPasswordWidget(
                        length: 6,
                        appTheme: appTheme,
                        fillIndex: _fillIndex,
                      ),
                    ],
                  ),
                ),
                KeyboardNumberWidget(
                  onKeyboardTap: (text) {
                    if(_fillIndex == 5){
                      /// Check correct password
                      return;
                    }
                    _fillIndex ++;
                    setState(() {

                    });
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
