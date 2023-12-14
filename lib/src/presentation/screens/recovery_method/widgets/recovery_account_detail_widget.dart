import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';

class RecoveryAccountDetailWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String accountName;
  final String address;
  final String? recoveryMethod;
  final String? recoveryValue;
  final VoidCallback onCopyAddress;
  final VoidCallback onChangeRecoverMethod;

  const RecoveryAccountDetailWidget({
    super.key,
    required this.appTheme,
    required this.accountName,
    required this.address,
    required this.onCopyAddress,
    required this.onChangeRecoverMethod,
    this.recoveryMethod,
    this.recoveryValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing08,
        top: Spacing.spacing04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ScrollViewWidget(
            appTheme: appTheme,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing06,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing04,
                    vertical: Spacing.spacing05,
                  ),
                  margin: const EdgeInsets.only(
                    top: Spacing.spacing06,
                  ),
                  decoration: BoxDecoration(
                    color: appTheme.surfaceColorGrayLight,
                    borderRadius: BorderRadius.circular(
                      BorderRadiusSize.borderRadius05,
                    ),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AssetIconPath.commonSmartAccountAvatarDefault,
                      ),
                      const SizedBox(
                        width: BoxSize.boxSize05,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              accountName,
                              style: AppTypoGraPhy.heading02.copyWith(
                                color: appTheme.contentColor700,
                              ),
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  address.addressView,
                                  style: AppTypoGraPhy.body03.copyWith(
                                    color: appTheme.contentColor700,
                                  ),
                                ),
                                const SizedBox(
                                  width: BoxSize.boxSize04,
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: onCopyAddress,
                                  child: SvgPicture.asset(
                                    AssetIconPath.recoveryMethodCopy,
                                  ),
                                ),
                              ],
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
                                      style:
                                          AppTypoGraPhy.bodyMedium02.copyWith(
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onChangeRecoverMethod,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetIconPath.recoveryMethodChange,
                      ),
                      const SizedBox(
                        width: BoxSize.boxSize06,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey
                                  .recoveryMethodScreenChangeRecoveryMethod,
                            ),
                            style: AppTypoGraPhy.bodyMedium03.copyWith(
                              color: appTheme.contentColor700,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
