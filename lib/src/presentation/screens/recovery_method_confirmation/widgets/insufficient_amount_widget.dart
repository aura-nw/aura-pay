import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/aura_smart_account_base_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InsufficientAmountWidget extends StatelessWidget {
  final String address;
  final String accountName;
  final AppTheme appTheme;
  final void Function(String) onCopy;

  const InsufficientAmountWidget({
    required this.address,
    required this.accountName,
    required this.appTheme,
    required this.onCopy,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    LanguageKey
                        .recoveryMethodConfirmationScreenInsufficientAmountTitle,
                  ),
                  style: AppTypoGraPhy.heading02.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () => AppNavigator.pop(),
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                AssetIconPath.commonCloseBottomSheet,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey
                    .recoveryMethodConfirmationScreenInsufficientAmountContent,
              ),
              style: AppTypoGraPhy.body02.copyWith(
                color: appTheme.contentColor500,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        QrImageView(
          data: address,
          version: QrVersions.auto,
          padding: EdgeInsets.zero,
          backgroundColor: appTheme.bodyColorBackground,
          size: context.w / 2,
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        GestureDetector(
          onTap: () => onCopy(address),
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(
              Spacing.spacing04,
            ),
            decoration: BoxDecoration(
              color: appTheme.surfaceColorGrayLight,
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius05,
              ),
            ),
            child: _InsufficientAccountWidget(
              appTheme: appTheme,
              address: address,
              accountName: accountName,
            ),
          ),
        ),
      ],
    );
  }
}

class _InsufficientAccountWidget extends AuraSmartAccountBaseWidget {
  const _InsufficientAccountWidget({
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
        color: appTheme.contentColor700,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget actionFormBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonCopy,
    );
  }

  @override
  Widget addressBuilder(BuildContext context) {
    return Text(
      address.addressView,
      style: AppTypoGraPhy.body03.copyWith(
        color: appTheme.contentColor700,
      ),
    );
  }

  @override
  Widget avatarBuilder(BuildContext context) {
    return SvgPicture.asset(
      AssetIconPath.commonSmartAccountAvatarDefault,
    );
  }
}
