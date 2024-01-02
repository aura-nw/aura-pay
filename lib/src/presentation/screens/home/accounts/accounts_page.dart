import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/aura_scan.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/app_launcher.dart';
import 'package:pyxis_mobile/src/core/helpers/share_network.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/accounts/widgets/account_manager_action_form.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/accounts/widgets/remove_account_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/accounts/widgets/rename_account_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'widgets/account_item_widget.dart';
import 'widgets/account_manager_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> with CustomFlutterToast {
  late HomeScreenBloc _homeScreenBloc;

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeScreenBloc = HomeScreenBloc.of(context);
  }

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
                // Account Manager Form Widget
                AccountManagerFormWidget(
                  appTheme: appTheme,
                  onCreateTap: () async {
                    await AppNavigator.push(
                      RoutePath.signedInCreateNewAccountPickName,
                    );

                    _homeScreenBloc.add(
                      const HomeScreenEventOnReFetchAccount(),
                    );
                  },
                  onImportTap: () async {
                    await AppNavigator.push(
                      RoutePath.signedInImportKey,
                    );

                    _homeScreenBloc.add(
                      const HomeScreenEventOnReFetchAccount(),
                    );
                  },
                  onRecoverTap: () async {
                    await AppNavigator.push(
                      RoutePath.signedInRecoverChoice,
                    );
                    _homeScreenBloc.add(
                      const HomeScreenEventOnReFetchAccount(),
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
                // App Localization Provider
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
                // Home Screen Selected Account Selector
                HomeScreenSelectedAccountSelector(
                  builder: (account) {
                    return AccountItemWidget(
                      appTheme: appTheme,
                      address: account?.address ?? '',
                      accountName: account?.name ?? '',
                      onMoreTap: () {
                        _showMoreOptionsDialog(
                          appTheme,
                          account!,
                        );
                      },
                      onUsing: true,
                      isSmartAccount: account?.isSmartAccount ?? false,
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize06,
                ),
                Expanded(
                  child: HomeScreenAccountsSelector(
                    builder: (accounts) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Localization Provider
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translateWithParam(
                                  LanguageKey.accountsPageAllAccounts,
                                  {
                                    'total': accounts.length,
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
                            child: ListView.builder(
                              itemCount: accounts.length,
                              itemBuilder: (context, index) {
                                final account = accounts[index];
                                return Column(
                                  children: [
                                    AccountItemWidget(
                                      appTheme: appTheme,
                                      address: account.address,
                                      accountName: account.name,
                                      onMoreTap: () {
                                        _showMoreOptionsDialog(
                                          appTheme,
                                          account,
                                        );
                                      },
                                      onChoose: () {
                                        _onChooseAccount(account);
                                      },
                                      isSmartAccount: account.isSmartAccount,
                                    ),
                                    const SizedBox(
                                      height: BoxSize.boxSize07,
                                    ),
                                  ],
                                );
                              },
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMoreOptionsDialog(AppTheme appTheme, AuraAccount account) {
    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: AccountManagerActionForm(
        address: account.address,
        name: account.name,
        appTheme: appTheme,
        isSmartAccount: account.isSmartAccount,
        onRemove: () {
          AppNavigator.pop();

          _showRemoveDialog(
            appTheme,
            account,
          );
        },
        onRenameAddress: () async {
          AppNavigator.pop();

          _showRenameDialog(
            appTheme,
            account,
          );
        },
        onShareAddress: () async {
          await ShareNetWork.shareWalletAddress(
            account.address,
          );
        },
        onViewOnAuraScan: () async {
          await AppLauncher.launch(
            AuraScan.account(
              account.address,
            ),
          );
        },
      ),
    );
  }

  void _showRenameDialog(AppTheme appTheme, AuraAccount account) {
    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: RenameAccountFormWidget(
        appTheme: appTheme,
        address: account.address,
        accountNameDefault: account.name,
        onConfirm: (newName) {
          showSuccessToast(
            AppLocalizationManager.of(context).translate(
              LanguageKey.accountsPageRenameAccountSuccess,
            ),
          );

          AppNavigator.pop();

          _homeScreenBloc.add(
            HomeScreenEventOnRenameAccount(
              account.id,
              newName,
            ),
          );
        },
      ),
    );
  }

  void _showRemoveDialog(AppTheme appTheme, AuraAccount account) {
    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      canBack: true,
      widget: RemoveAccountFormWidget(
        appTheme: appTheme,
        address: account.address,
        onRemove: () {
          if (_homeScreenBloc.state.accounts.length == 1) {
            AppGlobalCubit.of(context).changeState(
              const AppGlobalState(
                status: AppGlobalStatus.unauthorized,
              ),
            );
          }
          _homeScreenBloc.add(
            HomeScreenEventOnRemoveAccount(
              account.id,
              account.address,
            ),
          );
        },
      ),
    );
  }

  void _onChooseAccount(AuraAccount account) {
    HomeScreenBloc.of(context).add(
      HomeScreenEventOnChooseAccount(
        account,
      ),
    );

    // refresh token home
    _observer.emit(
      emitParam: {
        HomeScreenObserver.onSelectedAccountChangeEvent: account,
      },
    );
  }
}
