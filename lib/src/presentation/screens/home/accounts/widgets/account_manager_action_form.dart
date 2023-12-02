import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/accounts/widgets/account_item_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';

class AccountManagerActionForm extends StatelessWidget {
  final VoidCallback onShareAddress;
  final VoidCallback onRenameAddress;
  final VoidCallback onViewOnAuraScan;
  final VoidCallback onRemove;
  final AppTheme appTheme;
  final GlobalActiveAccount account;

  const AccountManagerActionForm({
    required this.appTheme,
    required this.onRemove,
    required this.onRenameAddress,
    required this.onShareAddress,
    required this.onViewOnAuraScan,
    required this.account,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing08,
        top: Spacing.spacing04,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing06,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ScrollViewWidget(
                    appTheme: appTheme,
                  ),
                ),
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
                  child: AccountItemImportedWidget(
                    appTheme: appTheme,
                    address: account.address,
                    accountName: account.accountName,
                  ),
                ),
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                _buildOptions(
                  AssetIconPath.accountsShare,
                  LanguageKey.accountsPageSendAddress,
                  onTap: onShareAddress,
                ),
                const SizedBox(
                  height: BoxSize.boxSize08,
                ),
                _buildOptions(
                  AssetIconPath.accountsRename,
                  LanguageKey.accountsPageRenameAccount,
                  onTap: onRenameAddress,
                ),
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                _buildOptions(
                  AssetIconPath.accountsViewOnAuraScan,
                  LanguageKey.accountsPageViewOnAuraScan,
                  onTap: onViewOnAuraScan,
                ),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
              ],
            ),
          ),
          const HoLiZonTalDividerWidget(),
          const SizedBox(
            height: BoxSize.boxSize07,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing06,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AssetIconPath.accountsRemove,
                  ),
                  const SizedBox(
                    width: BoxSize.boxSize04,
                  ),
                  Expanded(
                    child: AppLocalizationProvider(
                      builder: (localization, _) {
                        return Text(
                          localization.translate(
                            LanguageKey.accountsPageRemove,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypoGraPhy.bodyMedium03.copyWith(
                            color: appTheme.contentColorDanger,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOptions(
    String iconPath,
    String optionKey, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
          ),
          const SizedBox(
            width: BoxSize.boxSize04,
          ),
          Expanded(
            child: AppLocalizationProvider(
              builder: (localization, _) {
                return Text(
                  localization.translate(
                    optionKey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypoGraPhy.bodyMedium03.copyWith(
                    color: appTheme.contentColor700,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
