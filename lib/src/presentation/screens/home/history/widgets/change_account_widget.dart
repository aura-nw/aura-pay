import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/history/widgets/account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_view_widget.dart';

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
                LanguageKey.transactionHistoryPageSelectAccount,
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
                    bottom: Spacing.spacing06,
                  ),
                  child: HistoryAccountChangeWidget(
                    account: account,
                    isFirst: isSelected(account),
                    appTheme: appTheme,
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
