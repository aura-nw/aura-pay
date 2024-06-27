import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';

class AccountRecoveryWidget extends StatelessWidget {
  final String accountName;
  final String address;
  final bool isVerified;
  final String? recoveryMethod;
  final String? recoveryValue;
  final AppTheme appTheme;
  final VoidCallback onTap;

  const AccountRecoveryWidget({
    required this.accountName,
    required this.address,
    required this.isVerified,
    this.recoveryMethod,
    this.recoveryValue,
    required this.appTheme,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: Spacing.spacing08,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        accountName,
                        maxLines: 1,
                        style: AppTypoGraPhy.heading02.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                      ),
                      const SizedBox(
                        width: BoxSize.boxSize03,
                      ),
                      isVerified
                          ? SvgPicture.asset(
                              AssetIconPath.recoveryMethodCheck,
                            )
                          : SvgPicture.asset(
                              AssetIconPath.recoveryMethodWarning,
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize02,
                  ),
                  Text(
                    address.addressView,
                    style: AppTypoGraPhy.body02.copyWith(
                      color: appTheme.contentColor500,
                    ),
                  ),
                  if (recoveryMethod != null) ...[
                    const SizedBox(
                      height: BoxSize.boxSize02,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${recoveryMethod ?? ''}: ',
                            style: AppTypoGraPhy.body02.copyWith(
                              color: appTheme.contentColor500,
                            ),
                          ),
                          TextSpan(
                            text: recoveryValue ?? '',
                            style: AppTypoGraPhy.bodyMedium02.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else
                    const SizedBox.shrink(),
                ],
              ),
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            isVerified
                ? SvgPicture.asset(
                    AssetIconPath.commonMore,
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing05,
                      vertical: Spacing.spacing03,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        BorderRadiusSize.borderRadiusRound,
                      ),
                      border: Border.all(
                        color: appTheme.borderColorGrayDefault,
                      ),
                    ),
                    child: AppLocalizationProvider(
                      builder: (localization, _) {
                        return Text(
                          localization.translate(
                            LanguageKey.recoveryMethodScreenSet,
                          ),
                          style: AppTypoGraPhy.bodyMedium03.copyWith(
                            color: appTheme.contentColor700,
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
