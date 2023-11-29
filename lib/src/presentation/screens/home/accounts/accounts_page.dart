import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/accounts/widgets/account_manager_action_form.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'widgets/account_item_widget.dart';
import 'widgets/account_manager_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          appBar: AppBarWithOnlyTitle(
            appTheme: appTheme,
            titleKey: LanguageKey.accountsPageAppBarTitle,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountManagerFormWidget(
                  appTheme: appTheme,
                  onCreateTap: () {},
                  onImportTap: () {},
                  onRecoverTap: () {},
                ),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translate(
                        LanguageKey.accountsPageUsing,
                      ),
                      style: AppTypoGraPhy.bodyMedium03.copyWith(
                        color: appTheme.contentColorBlack,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                BlocBuilder<AppGlobalCubit, AppGlobalState>(
                  bloc: AppGlobalCubit.of(
                    context,
                  ),
                  builder: (context, state) {
                    return AccountItemWidget(
                      appTheme: appTheme,
                      address: state.accounts.first.address,
                      accountName: state.accounts.first.accountName,
                      onMoreTap: () {
                        _showMoreOptionsDialog(
                          appTheme,
                          state.accounts.first,
                        );
                      },
                      onUsing: true,
                      isSmartAccount: true,
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return Text(
                      localization.translateWithParam(
                        LanguageKey.accountsPageAllAccounts,
                        {
                          'total': 3,
                        },
                      ),
                      style: AppTypoGraPhy.bodyMedium03.copyWith(
                        color: appTheme.contentColorBlack,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize07,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      BlocBuilder<AppGlobalCubit, AppGlobalState>(
                        bloc: AppGlobalCubit.of(
                          context,
                        ),
                        builder: (context, state) {
                          return AccountItemWidget(
                            appTheme: appTheme,
                            address: state.accounts.first.address,
                            accountName: state.accounts.first.accountName,
                            onMoreTap: () {},
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize07,
                      ),
                      BlocBuilder<AppGlobalCubit, AppGlobalState>(
                        bloc: AppGlobalCubit.of(
                          context,
                        ),
                        builder: (context, state) {
                          return AccountItemWidget(
                            appTheme: appTheme,
                            address: state.accounts.first.address,
                            accountName: state.accounts.first.accountName,
                            onMoreTap: () {},
                            isSmartAccount: true,
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize07,
                      ),
                      BlocBuilder<AppGlobalCubit, AppGlobalState>(
                        bloc: AppGlobalCubit.of(
                          context,
                        ),
                        builder: (context, state) {
                          return AccountItemWidget(
                            appTheme: appTheme,
                            address: state.accounts.first.address,
                            accountName: state.accounts.first.accountName,
                            onMoreTap: () {},
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoreOptionsDialog(AppTheme appTheme, GlobalActiveAccount account) {
    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: AccountManagerActionForm(
        account: account,
        appTheme: appTheme,
        onRemove: () {
          AppNavigator.pop();
        },
        onRenameAddress: () {},
        onShareAddress: () {},
        onViewOnAuraScan: () {},
      ),
    );
  }
}
