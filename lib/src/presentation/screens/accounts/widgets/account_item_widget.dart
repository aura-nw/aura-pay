import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';

class AccountItemWidget extends StatelessWidget {
  final bool onUsing;
  final bool isSmartAccount;
  final String address;
  final String accountName;
  final AppTheme appTheme;
  final VoidCallback onMoreTap;
  final VoidCallback? onChoose;

  const AccountItemWidget({
    this.onUsing = false,
    this.isSmartAccount = false,
    required this.appTheme,
    required this.address,
    required this.accountName,
    required this.onMoreTap,
    this.onChoose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChoose,
      child: Container(
        padding: const EdgeInsets.all(
          Spacing.spacing03,
        ),
        decoration: BoxDecoration(
          color: onUsing ? appTheme.surfaceColorBrandLight : null,
          borderRadius: onUsing
              ? BorderRadius.circular(
                  BorderRadiusSize.borderRadius04,
                )
              : null,
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
                        if (isSmartAccount) ...[
                          const SizedBox(
                            height: BoxSize.boxSize02,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.spacing03,
                              vertical: Spacing.spacing01,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                BorderRadiusSize.borderRadiusRound,
                              ),
                              color: appTheme.surfaceColorBrandSemiLight,
                            ),
                            child: AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(
                                    LanguageKey.inAppBrowserScreenSmartAccount,
                                  ),
                                  style: AppTypoGraPhy.body01.copyWith(
                                    color: appTheme.contentColorBrand,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onUsing) ...[
                    const SizedBox(
                      width: BoxSize.boxSize05,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AssetIconPath.commonRadioCheck,
                      ),
                    ),
                  ] else
                    const SizedBox.shrink(),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onMoreTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.spacing04,
                      ),
                      child: onUsing
                          ? SvgPicture.asset(
                        AssetIconPath.commonMoreActive,
                      )
                          : SvgPicture.asset(
                        AssetIconPath.commonMore,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountItemImportedWidget extends AuraSmartAccountBaseWidget {
  final bool isSmartAccount;

  const AccountItemImportedWidget({
    this.isSmartAccount = false,
    required super.appTheme,
    required super.address,
    required super.accountName,
    super.key,
  });

  @override
  Widget accountNameBuilder(BuildContext context) {
    return Text(
      accountName,
      style: AppTypoGraPhy.heading02.copyWith(
        color: appTheme.contentColorBlack,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget actionFormBuilder(BuildContext context) {
    return isSmartAccount
        ? const SizedBox.shrink()
        : Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing03,
              vertical: Spacing.spacing02,
            ),
            decoration: BoxDecoration(
              color: appTheme.surfaceColorGrayDark,
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadiusRound,
              ),
            ),
            child: AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    LanguageKey.accountsScreenImported,
                  ),
                  style: AppTypoGraPhy.body02.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                  textAlign: TextAlign.end,
                );
              },
            ),
          );
  }

  @override
  Widget addressBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          address.addressView,
          style: AppTypoGraPhy.body02.copyWith(
            color: appTheme.contentColor500,
          ),
        ),
        const SizedBox(
          width: BoxSize.boxSize02,
        ),
        SvgPicture.asset(
          AssetIconPath.commonCopy,
        ),
      ],
    );
  }

  @override
  Widget avatarBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonSmartAccountAvatarDefault,
    );
  }
}
