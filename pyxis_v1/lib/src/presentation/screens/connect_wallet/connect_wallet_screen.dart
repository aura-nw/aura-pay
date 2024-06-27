import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_cubit.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'widgets/connect_wallet_reason_widget.dart';
import 'connect_wallet_cubit.dart';
import 'connect_wallet_selector.dart';
import 'connect_wallet_state.dart';
import 'widgets/connect_wallet_account_form_widget.dart';
import 'widgets/connect_wallet_choose_account_form_widget.dart';
import 'widgets/connect_wallet_information_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';

class ConnectWalletScreen extends StatefulWidget {
  final ConnectingData connectingData;

  const ConnectWalletScreen({
    Key? key,
    required this.connectingData,
  }) : super(key: key);

  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen> {
  final ConnectWalletCubit _cubit = getIt.get<ConnectWalletCubit>();
  final HomeScreenObserver _homeScreenObserver =
      getIt.get<HomeScreenObserver>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _cubit,
          child: Scaffold(
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey: Uri.parse(widget.connectingData.urlConnect).host,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing05,
                ),
                child: ConnectWalletStatusSelector(
                  builder: (status) {
                    switch (status) {
                      case ConnectWalletStatus.loading:
                        return Center(
                          child: AppLoadingWidget(
                            appTheme: appTheme,
                          ),
                        );
                      case ConnectWalletStatus.loaded:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: [
                                  ConnectWalletInformationWidget(
                                    url: widget.connectingData.urlConnect,
                                    logo: widget.connectingData.logo,
                                    appTheme: appTheme,
                                  ),
                                  const SizedBox(
                                    height: BoxSize.boxSize07,
                                  ),
                                  ConnectWalletAccountsSelector(
                                    builder: (accounts) {
                                      return ConnectWalletSelectedAccountSelector(
                                        builder: (selectedAccount) {
                                          return GestureDetector(
                                            onTap: () {
                                              _onShowAccounts(
                                                accounts: accounts,
                                                appTheme: appTheme,
                                                selectedAccount:
                                                    selectedAccount,
                                              );
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child:
                                                ConnectWalletAccountFormWidget(
                                              appTheme: appTheme,
                                              address:
                                                  selectedAccount?.address ??
                                                      '',
                                              accountName:
                                                  selectedAccount?.name ?? '',
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: BoxSize.boxSize07,
                                  ),
                                  ConnectWalletReasonWidget(
                                    appTheme: appTheme,
                                  ),
                                ],
                              ),
                            ),
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return PrimaryAppButton(
                                  text: localization.translate(
                                    LanguageKey.connectWalletScreenButtonTitle,
                                  ),
                                  onPress: _onConnectData,
                                );
                              },
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConnectData() {
    WalletConnectCubit.of(context).approveConnection(widget.connectingData);

    AppNavigator.pop();
  }

  void _onShowAccounts({
    required List<AuraAccount> accounts,
    required AppTheme appTheme,
    AuraAccount? selectedAccount,
  }) async {
    final account = await DialogProvider.showCustomDialog<AuraAccount?>(
      context,
      appTheme: appTheme,
      widget: ConnectWalletChooseAccountFormWidget(
        accounts: accounts,
        appTheme: appTheme,
        isSelected: (account) {
          return account.id == selectedAccount?.id;
        },
      ),
      canBack: true,
    );

    if (account != null && account.id != _cubit.state.choosingAccount?.id) {
      _homeScreenObserver.emit(
        emitParam: HomeScreenEmitParam(
          event: HomeScreenObserver.onConnectWalletChooseAccountEvent,
          data: account,
        ),
      );

      _cubit.onChoseNewAccount(
        account,
      );
    }
  }
}
