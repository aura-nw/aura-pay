import 'package:flutter/material.dart';
import 'package:aurapay/src/application/global/app_theme/app_theme.dart';
import 'package:aurapay/src/application/global/localization/localization_manager.dart';
import 'package:aurapay/src/core/constants/language_key.dart';
import 'package:aurapay/src/core/constants/size_constant.dart';
import 'package:aurapay/src/core/constants/typography.dart';
import 'package:aurapay/src/navigator.dart';
import 'package:aurapay/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_base.dart';
import 'package:aurapay/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_provider.dart';

final class AddWalletMenuBottomSheet extends AppBottomSheetBase {
  final VoidCallback? onCreateNewWallet;
  final VoidCallback? onAddExistingWallet;

  const AddWalletMenuBottomSheet({
    super.key,
    required super.appTheme,
    required super.localization,
    this.onCreateNewWallet,
    this.onAddExistingWallet,
  });

  @override
  State<StatefulWidget> createState() => _AddWalletMenuBottomSheetState();
}

class _AddWalletMenuBottomSheetState
    extends AppBottomSheetBaseState<AddWalletMenuBottomSheet> {
  @override
  Widget titleBuilder(BuildContext context) {
    return Text(
      localization.translate(LanguageKey.manageWalletScreenMenuTitle),
      style: AppTypoGraPhy.textLgBold.copyWith(
        color: appTheme.textPrimary,
      ),
    );
  }

  @override
  Widget subTitleBuilder(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget contentBuilder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: Spacing.spacing05),
        _buildMenuItem(
          context: context,
          title: localization.translate(LanguageKey.manageWalletScreenCreateNew),
          icon: Icons.add,
          isHighlighted: true,
          onTap: () {
            AppNavigator.pop();
            if (widget.onCreateNewWallet != null) {
              widget.onCreateNewWallet!();
            }
          },
        ),
        const SizedBox(height: Spacing.spacing03),
        _buildMenuItem(
          context: context,
          title: localization.translate(LanguageKey.manageWalletScreenAddExisting),
          icon: Icons.upload_file,
          isHighlighted: false,
          onTap: () {
            AppNavigator.pop();
            if (widget.onAddExistingWallet != null) {
              widget.onAddExistingWallet!();
            }
          },
        ),
        const SizedBox(height: Spacing.spacing05),
      ],
    );
  }

  @override
  Widget bottomBuilder(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isHighlighted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(Spacing.spacing04),
        decoration: BoxDecoration(
          color: isHighlighted
              ? appTheme.bgBrandPrimary.withOpacity(0.1)
              : appTheme.bgSecondary,
          borderRadius: BorderRadius.circular(
            BorderRadiusSize.borderRadius04,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? appTheme.bgBrandPrimary
                    : appTheme.bgSecondary,
                borderRadius: BorderRadius.circular(
                  BorderRadiusSize.borderRadius03,
                ),
              ),
              child: Icon(
                icon,
                color: isHighlighted
                    ? Colors.white
                    : appTheme.fgPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: Spacing.spacing04),
            Expanded(
              child: Text(
                title,
                style: AppTypoGraPhy.textMdMedium.copyWith(
                  color: appTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

