import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';

class AccountItemWidget extends AuraSmartAccountBaseWidget {
  final bool onUsing;
  final bool isSmartAccount;
  final VoidCallback onMoreTap;
  final VoidCallback? onChoose;

  const AccountItemWidget({
    this.onUsing = false,
    this.isSmartAccount = false,
    required super.appTheme,
    required super.address,
    required super.accountName,
    required this.onMoreTap,
    this.onChoose,
    super.key,
  });

  @override
  Widget accountNameBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChoose,
      child: Row(
        children: [
          Text(
            accountName,
            style: AppTypoGraPhy.heading02.copyWith(
              color: appTheme.contentColorBlack,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (onUsing) ...[
            const SizedBox(
              width: BoxSize.boxSize03,
            ),
            SvgPicture.asset(
              AssetIconPath.commonAccountCheck,
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget actionFormBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onMoreTap,
      child: Padding(
        padding: isSmartAccount
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
                horizontal: Spacing.spacing04,
              ),
        child: Row(
          children: [
            if (isSmartAccount) ...[
              Container(
                padding: const EdgeInsets.all(
                  Spacing.spacing02,
                ),
                margin: const EdgeInsets.only(
                  right: Spacing.spacing06,
                ),
                decoration: BoxDecoration(
                  color: appTheme.surfaceColorBrandLight,
                  borderRadius: BorderRadius.circular(
                    BorderRadiusSize.borderRadiusRound,
                  ),
                ),
                child: AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        LanguageKey.accountsScreenSmartAccountLabel,
                      ),
                      style: AppTypoGraPhy.body02.copyWith(
                        color: appTheme.contentColorBrand,
                      ),
                    );
                  },
                ),
              ),
            ],
            SvgPicture.asset(
              AssetIconPath.commonMore,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget addressBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChoose,
      child: Text(
        address.addressView,
        style: AppTypoGraPhy.body02.copyWith(
          color: appTheme.contentColor500,
        ),
      ),
    );
  }

  @override
  Widget avatarBuilder(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onChoose,
      child: SvgPicture.asset(
        AssetIconPath.commonSmartAccountAvatarDefault,
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
