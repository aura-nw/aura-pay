import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'widgets/account_form_widget.dart';
import 'controller_key_management_cubit.dart';
import 'controller_key_management_state.dart';
import 'controller_key_management_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/combine_list_view.dart';

class ControllerKeyManagementScreen extends StatefulWidget {
  const ControllerKeyManagementScreen({super.key});

  @override
  State<ControllerKeyManagementScreen> createState() =>
      _ControllerKeyManagementScreenState();
}

class _ControllerKeyManagementScreenState
    extends State<ControllerKeyManagementScreen> {
  final ControllerKeyManagementCubit _cubit =
      getIt.get<ControllerKeyManagementCubit>();

  @override
  void initState() {
    _cubit.fetchAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: AppThemeBuilder(
        builder: (appTheme) {
          return Scaffold(
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey: LanguageKey.controllerKeyManagementScreenAppbarTitle,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing05,
                  vertical: Spacing.spacing07,
                ),
                child: ControllerKeyManagementStatusSelector(
                  builder: (status) {
                    switch (status) {
                      case ControllerKeyManagementStatus.loading:
                        return Center(
                          child: AppLoadingWidget(
                            appTheme: appTheme,
                          ),
                        );
                      case ControllerKeyManagementStatus.loaded:
                      case ControllerKeyManagementStatus.error:
                        return ControllerKeyManagementAccountsSelector(
                          builder: (accounts) {
                            return CombinedListView(
                              onRefresh: () {
                                //
                              },
                              onLoadMore: () {
                                //
                              },
                              data: accounts,
                              builder: (account, _) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Spacing.spacing04,
                                  ),
                                  child: AccountItemWidget(
                                    appTheme: appTheme,
                                    address: account.address,
                                    accountName: account.name,
                                    onTap: () {
                                      _onShowPrivateKey(
                                        account.address,
                                      );
                                    },
                                    type: account.createdType,
                                  ),
                                );
                              },
                              canLoadMore: false,
                            );
                          },
                        );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onShowPrivateKey(String address) {
    void onVerifySuccess() {
      AppNavigator.replaceWith(RoutePath.backUpPrivateKey, address);
    }

    AppNavigator.push(
      RoutePath.signedInVerifyPasscode,
      onVerifySuccess,
    );
  }
}
