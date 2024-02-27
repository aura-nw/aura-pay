import 'package:domain/domain.dart';
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
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';

class _AccountWidget extends StatelessWidget {
  final String address;
  final String accountName;
  final bool isSmartAccount;
  final bool isSelected;
  final AppTheme appTheme;

  const _AccountWidget({
    required this.address,
    required this.accountName,
    required this.isSmartAccount,
    required this.isSelected,
    required this.appTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing03,
      ),
      decoration: BoxDecoration(
        color: isSelected ? appTheme.surfaceColorBrandLight : null,
        borderRadius: isSelected
            ? BorderRadius.circular(
                BorderRadiusSize.borderRadius04,
              )
            : null,
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
                if(isSmartAccount) ... [
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
          if (isSelected) ...[
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
            SvgPicture.asset(
              AssetIconPath.commonRadioCheck,
            ),
            const SizedBox(
              width: BoxSize.boxSize05,
            ),
          ] else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class ChangeAccountFormWidget extends StatelessWidget {
  final List<AuraAccount> accounts;
  final AppTheme appTheme;
  final bool Function(AuraAccount) isSelected;

  const ChangeAccountFormWidget({
    required this.accounts,
    required this.appTheme,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        ScrollViewWidget(
          appTheme: appTheme,
        ),
        const SizedBox(
          height: BoxSize.boxSize05,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return Text(
              localization.translate(
                LanguageKey.inAppBrowserScreenChooseAccountDialogTitle,
              ),
              style: AppTypoGraPhy.heading02.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize06,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: BoxSize.boxSize18,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing05,
            ),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return GestureDetector(
                onTap: () {
                  AppNavigator.pop(account);
                },
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.spacing05,
                  ),
                  child: _AccountWidget(
                    isSelected: isSelected(account),
                    isSmartAccount: account.isSmartAccount,
                    appTheme: appTheme,
                    accountName: account.name,
                    address: account.address,
                    key: ValueKey(account),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
