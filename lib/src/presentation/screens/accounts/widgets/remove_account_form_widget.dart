import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class RemoveAccountFormWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String address;
  final VoidCallback onRemove;

  const RemoveAccountFormWidget({
    required this.appTheme,
    required this.address,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.spacing08,
        horizontal: Spacing.spacing06,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetIconPath.accountsRemoveWarning,
          ),
          const SizedBox(
            height: BoxSize.boxSize06,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  localization.translate(
                    LanguageKey.accountsScreenRemoveTitle,
                  ),
                ),
                style: AppTypoGraPhy.heading02.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          const SizedBox(
            height: BoxSize.boxSize03,
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return RichText(
                text: TextSpan(
                  style: AppTypoGraPhy.bodyMedium02.copyWith(
                    color: appTheme.contentColor500,
                  ),
                  children: [
                    TextSpan(
                      text: localization.translate(
                        LanguageKey.accountsScreenRemoveContentRegionOne,
                      ),
                    ),
                    TextSpan(
                      text: ' ${localization.translateWithParam(
                        LanguageKey.accountsScreenRemoveContentRegionTwo,
                        {
                          'address': address.addressView,
                        },
                      )} ',
                      style: AppTypoGraPhy.bodyMedium03.copyWith(
                        color: appTheme.contentColorDanger,
                      ),
                    ),
                    TextSpan(
                      text: localization.translate(
                        LanguageKey.accountsScreenRemoveContentRegionThree,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: BoxSize.boxSize09,
          ),
          Row(
            children: [
              Expanded(
                child: AppLocalizationProvider(
                  builder: (localization, _) {
                    return BorderAppButton(
                      text: localization.translate(
                        LanguageKey.accountsScreenRemoveCancelTitle,
                      ),
                      onPress: () {
                        AppNavigator.pop();
                      },
                      textColor: appTheme.contentColorBlack,
                      borderColor: appTheme.borderColorGrayDefault,
                    );
                  },
                ),
              ),
              const SizedBox(
                width: BoxSize.boxSize07,
              ),
              Expanded(
                child: AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey.accountsScreenRemoveRemoveTitle,
                      ),
                      onPress: () {
                        AppNavigator.pop();

                        onRemove();
                      },
                      backGroundColor: appTheme.surfaceColorDangerDark,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
