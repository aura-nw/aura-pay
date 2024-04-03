import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

class AccountItemWidget extends StatelessWidget {
  final String address;
  final String accountName;
  final AppTheme appTheme;
  final VoidCallback onTap;
  final AuraAccountCreateType type;

  const AccountItemWidget({
    required this.appTheme,
    required this.address,
    required this.accountName,
    required this.onTap,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(
          Spacing.spacing03,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              AssetIconPath.commonSmartAccountAvatarDefault,
              width: BoxSize.boxSize09,
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accountName,
                          style: AppTypoGraPhy.heading01.copyWith(
                            color: appTheme.contentColorBlack,
                          ),
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize01,
                        ),
                        Text(
                          address.addressView,
                          style: AppTypoGraPhy.body02.copyWith(
                            color: appTheme.contentColor500,
                          ),
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize02,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _containerBox(
                              child: AppLocalizationProvider(
                                builder: (localization, _) {
                                  return Text(
                                    localization.translate(
                                      LanguageKey
                                          .controllerKeyManagementScreenNormalWallet,
                                    ),
                                    style: AppTypoGraPhy.bodyMedium01.copyWith(
                                      color: appTheme.contentColor300,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: BoxSize.boxSize04,
                            ),
                            _genderByType(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: BoxSize.boxSize05,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AssetIconPath.commonArrowNext,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _containerBox({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.spacing03,
        vertical: Spacing.spacing01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius02,
        ),
        color: appTheme.surfaceColorGrayDefault,
      ),
      child: child,
    );
  }

  Widget _genderByType() {
    switch (type) {
      case AuraAccountCreateType.normal:
        return const SizedBox.shrink();
      case AuraAccountCreateType.google:
        return AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.controllerKeyManagementScreenGoogleConnected,
              ),
              style: AppTypoGraPhy.bodyMedium01.copyWith(
                color: appTheme.contentColor300,
              ),
            );
          },
        );
      case AuraAccountCreateType.import:
        return AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.controllerKeyManagementScreenImported,
              ),
              style: AppTypoGraPhy.bodyMedium01.copyWith(
                color: appTheme.contentColor300,
              ),
            );
          },
        );
    }
  }
}
