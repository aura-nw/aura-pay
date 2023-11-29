import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';

class AccountManagerFormWidget extends StatelessWidget {
  final AppTheme appTheme;
  final VoidCallback onCreateTap;
  final VoidCallback onImportTap;
  final VoidCallback onRecoverTap;

  const AccountManagerFormWidget({
    super.key,
    required this.appTheme,
    required this.onCreateTap,
    required this.onImportTap,
    required this.onRecoverTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        Spacing.spacing05,
      ),
      decoration: BoxDecoration(
        color: appTheme.surfaceColorGrayLight,
        borderRadius: BorderRadius.circular(
          BorderRadiusSize.borderRadius05,
        ),
      ),
      child: Column(
        children: [
          _buildOptions(
            AssetIconPath.accountsCreateNewSmartAccount,
            LanguageKey.accountsPageCreateNewSmartAccount,
            onTap: onCreateTap,
          ),
          const SizedBox(
            height: BoxSize.boxSize06,
          ),
          _buildOptions(
            AssetIconPath.accountsImportExistingAccount,
            LanguageKey.accountsPageImportExistingAccount,
            onTap: onImportTap,
          ),
          const SizedBox(
            height: BoxSize.boxSize06,
          ),
          _buildOptions(
            AssetIconPath.accountsRecoverSmartAccount,
            LanguageKey.accountsPageRecoverAccount,
            onTap: onRecoverTap,
          ),
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
                  style: AppTypoGraPhy.bodyMedium03
                      .copyWith(color: appTheme.contentColor700),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
