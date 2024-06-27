import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';

class AddressBookDetailFormWidget extends StatelessWidget {
  final AppTheme appTheme;
  final String name;
  final String address;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const AddressBookDetailFormWidget({
    super.key,
    required this.appTheme,
    required this.name,
    required this.address,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Spacing.spacing07,
        horizontal: Spacing.spacing05,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ScrollViewWidget(
            appTheme: appTheme,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing05,
            ),
            width: double.maxFinite,
            margin: const EdgeInsets.only(
              top: Spacing.spacing06,
            ),
            decoration: BoxDecoration(
              color: appTheme.surfaceColorGrayLight,
              borderRadius: BorderRadius.circular(
                BorderRadiusSize.borderRadius05,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypoGraPhy.heading02.copyWith(
                    color: appTheme.contentColorBlack,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: BoxSize.boxSize02,
                ),
                Text(
                  address.addressView,
                  style: AppTypoGraPhy.body03.copyWith(
                    color: appTheme.contentColor500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: BoxSize.boxSize07,
          ),
          IconWithTextWidget(
            titlePath: LanguageKey.addressBookScreenEdit,
            svgIconPath: AssetIconPath.commonEdit,
            appTheme: appTheme,
            onTap: onEdit,
            spacing: Spacing.spacing05,
          ),
          const SizedBox(
            height: BoxSize.boxSize05,
          ),
          IconWithTextWidget(
            titlePath: LanguageKey.addressBookScreenRemove,
            svgIconPath: AssetIconPath.commonCloseCircle,
            appTheme: appTheme,
            onTap: onRemove,
            spacing: Spacing.spacing05,
          ),
        ],
      ),
    );
  }
}
