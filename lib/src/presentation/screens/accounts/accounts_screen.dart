import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_cubit.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/aura_scan.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/app_launcher.dart';
import 'package:pyxis_mobile/src/core/helpers/share_network.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/icon_with_text_widget.dart';
import 'widgets/account_manager_action_form.dart';
import 'widgets/remove_account_form_widget.dart';
import 'widgets/rename_account_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/home/home_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'widgets/account_item_widget.dart';
import 'widgets/account_manager_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class AccountsScreen extends StatefulWidget {
  final HomeScreenBloc homeScreenBloc;

  const AccountsScreen({
    required this.homeScreenBloc,
    super.key,
  });

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen>
    with CustomFlutterToast {
  late HomeScreenBloc _homeScreenBloc;

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  @override
  void initState() {
    super.initState();
    _homeScreenBloc = widget.homeScreenBloc;
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(
          builder: (localization, _) {
            return Scaffold(
              backgroundColor: appTheme.bodyColorBackground,
              appBar: AppBarDefault(
                appTheme: appTheme,
                title: localization.translate(
                  LanguageKey.accountsScreenAppBarTitle,
                ),
                actions: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: IconWithTextWidget(
                      titlePath: LanguageKey.accountsScreenAppBarAddAction,
                      svgIconPath: AssetIconPath.commonAddActive,
                      appTheme: appTheme,
                      style: AppTypoGraPhy.bodyMedium02.copyWith(
                        color: appTheme.contentColorBrand,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: BoxSize.boxSize05,
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Manager Form Widget
                    // AccountManagerFormWidget(
                    //   appTheme: appTheme,
                    //   onCreateTap: () async {
                    //     await AppNavigator.push(
                    //       RoutePath.signedInCreateNewAccountPickName,
                    //     );
                    //
                    //     _homeScreenBloc.add(
                    //       const HomeScreenEventOnReFetchAccount(),
                    //     );
                    //   },
                    //   onImportTap: () async {
                    //     await AppNavigator.push(
                    //       RoutePath.signedInImportKey,
                    //     );
                    //
                    //     _homeScreenBloc.add(
                    //       const HomeScreenEventOnReFetchAccount(),
                    //     );
                    //   },
                    //   onRecoverTap: () async {
                    //     await AppNavigator.push(
                    //       RoutePath.signedInRecoverChoice,
                    //     );
                    //     _homeScreenBloc.add(
                    //       const HomeScreenEventOnReFetchAccount(),
                    //     );
                    //   },
                    // ),
                    // const SizedBox(
                    //   height: BoxSize.boxSize06,
                    // ),
                    Expanded(
                      child: HomeScreenAccountsSelector(
                        bloc: _homeScreenBloc,
                        builder: (accounts) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // App Localization Provider
                              AppLocalizationProvider(
                                builder: (localization, _) {
                                  return Text(
                                    localization.translateWithParam(
                                      LanguageKey.accountsScreenAllAccounts,
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
                                height: BoxSize.boxSize04,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: accounts.length,
                                  itemBuilder: (context, index) {
                                    final account = accounts[index];
                                    return Column(
                                      children: [
                                        HomeScreenSelectedAccountSelector(
                                          bloc: _homeScreenBloc,
                                          builder: (selectedAccount) {
                                            return AccountItemWidget(
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
                                              isSmartAccount:
                                                  account.isSmartAccount,
                                              onUsing: account.id ==
                                                  selectedAccount?.id,
                                            );
                                          },
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
        onCopyAddress: () {
          _copyAddress(account.address);
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
              LanguageKey.accountsScreenRenameAccountSuccess,
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
    DialogProvider.showRemoveDialog(
      context,
      cancelKey: LanguageKey.accountsScreenRemoveCancelTitle,
      confirmKey: LanguageKey.accountsScreenRemoveRemoveTitle,
      content: RemoveAccountContentFormWidget(
        appTheme: appTheme,
        address: account.address,
      ),
      onRemove: () {
        if (_homeScreenBloc.state.accounts.length == 1) {
          AppGlobalCubit.of(context).changeState(
            const AppGlobalState(
              status: AppGlobalStatus.unauthorized,
            ),
          );
        } else {
          if (account.index == 0) {
            _observer.emit(
              emitParam: HomeScreenEmitParam(
                event: HomeScreenObserver.onSelectedAccountChangeEvent,
                data: _homeScreenBloc.state.accounts[1],
              ),
            );
          }
        }

        _homeScreenBloc.add(
          HomeScreenEventOnRemoveAccount(
            account.id,
            account.address,
          ),
        );
      },
      appTheme: appTheme,
    );
  }

  void _onChooseAccount(AuraAccount account) {
    WalletConnectCubit.of(context).registerSmartAccount(account.address);
    _homeScreenBloc.add(
      HomeScreenEventOnChooseAccount(
        account,
      ),
    );

    if (account.id != _homeScreenBloc.state.selectedAccount?.id) {
      // refresh token home
      _observer.emit(
        emitParam: HomeScreenEmitParam(
          event: HomeScreenObserver.onSelectedAccountChangeEvent,
          data: account,
        ),
      );
    }
  }

  void _copyAddress(String data) async {
    await Clipboard.setData(
      ClipboardData(text: data),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.globalPyxisCopyMessage,
            {
              'value': 'address',
            },
          ),
        );
      }
    }
  }
}
