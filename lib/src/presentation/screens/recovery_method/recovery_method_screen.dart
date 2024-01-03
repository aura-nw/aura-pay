import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/observers/recovery_observer.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method/widgets/recovery_account_detail_widget.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method/widgets/recovery_account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'recovery_method_screen_bloc.dart';
import 'recovery_method_screen_event.dart';
import 'recovery_method_screen_state.dart';
import 'recovery_method_screen_selector.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class RecoveryMethodScreen extends StatefulWidget {
  const RecoveryMethodScreen({super.key});

  @override
  State<RecoveryMethodScreen> createState() => _RecoveryMethodScreenState();
}

class _RecoveryMethodScreenState extends State<RecoveryMethodScreen>
    with CustomFlutterToast {
  final RecoveryMethodScreenBloc _bloc = getIt.get<RecoveryMethodScreenBloc>();

  final RecoveryObserver _recoveryObserver = getIt.get<RecoveryObserver>();

  @override
  void initState() {
    _bloc.add(
      const RecoveryMethodScreenEventFetchAccount(),
    );

    _recoveryObserver.addListener(_handleRecoveryConfirmationStatus);
    super.initState();
  }

  void _handleRecoveryConfirmationStatus(bool status, String? msg) async {
    // set recover success
    if (status) {
      // refresh account
      _bloc.add(
        const RecoveryMethodScreenEventRefresh(),
      );

      await Future.delayed(const Duration(
        microseconds: 2500,
      ));
      if (context.mounted) {
        showSuccessToast(
          AppLocalizationManager.of(context).translate(
            LanguageKey.recoveryMethodScreenSetRecoverySuccess,
          ),
          const Duration(
            seconds: 3,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _recoveryObserver.removeListener(_handleRecoveryConfirmationStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: Scaffold(
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey: LanguageKey.recoveryMethodScreenAppBarTitle,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing07,
                vertical: Spacing.spacing04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.recoveryMethodScreenContent,
                        ),
                        style: AppTypoGraPhy.body02.copyWith(
                          color: appTheme.contentColor700,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: BoxSize.boxSize08,
                  ),
                  Expanded(
                    child: RecoveryMethodScreenStatusSelector(
                      builder: (status) {
                        switch (status) {
                          case RecoveryMethodScreenStatus.loading:
                            return Center(
                              child: AppLoadingWidget(
                                appTheme: appTheme,
                              ),
                            );
                          case RecoveryMethodScreenStatus.loaded:
                          case RecoveryMethodScreenStatus.error:
                            return RecoveryMethodScreenAccountsSelector(
                              builder: (accounts) {
                                if (accounts.isEmpty) {
                                  return Center(
                                    child: AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return Text(
                                          localization.translate(
                                            localization.translate(
                                              LanguageKey
                                                  .recoveryMethodScreenNoAccountFound,
                                            ),
                                          ),
                                          style: AppTypoGraPhy.body02.copyWith(
                                            color: appTheme.contentColor500,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: accounts.length,
                                  itemBuilder: (context, index) {
                                    final account = accounts[index];
                                    String? recoveryMethod;
                                    String? recoverValue =
                                        account.method?.value;

                                    if (account.isVerified) {
                                      String? recoveryType;

                                      recoverValue = account.method?.method ==
                                              AuraSmartAccountRecoveryMethod
                                                  .web3Auth
                                          ? recoverValue
                                          : recoverValue.addressView;

                                      recoveryType = account.method?.method ==
                                              AuraSmartAccountRecoveryMethod
                                                  .web3Auth
                                          ? LanguageKey
                                              .recoveryMethodScreenGoogle
                                          : LanguageKey
                                              .recoveryMethodScreenBackupAddress;

                                      recoveryMethod =
                                          AppLocalizationManager.of(context)
                                              .translate(
                                        recoveryType,
                                      );
                                    }

                                    return AccountRecoveryWidget(
                                      accountName: account.name,
                                      address: account.address,
                                      isVerified: account.isVerified,
                                      appTheme: appTheme,
                                      recoveryMethod: recoveryMethod,
                                      recoveryValue: recoverValue,
                                      onTap: () => _onAccountTap(
                                        account,
                                        appTheme,
                                        recoveryMethod,
                                        recoverValue,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onAccountTap(
    AuraAccount account,
    AppTheme appTheme,
    String? recoveryMethod,
    String? recoverValue,
  ) async {
    if (!account.isVerified) {
      AppNavigator.push(
        RoutePath.setRecoverMethod,
        account,
      );
    } else {
      DialogProvider.showCustomDialog(
        context,
        appTheme: appTheme,
        canBack: true,
        widget: RecoveryAccountDetailWidget(
          appTheme: appTheme,
          accountName: account.name,
          address: account.address,
          recoveryMethod: recoveryMethod,
          recoveryValue: recoverValue,
          onCopyAddress: () => _onCopyAddress(
            account.address,
          ),
          onChangeRecoverMethod: () {
            AppNavigator.pop();
            AppNavigator.push(
              RoutePath.setRecoverMethod,
              account,
            );
          },
        ),
      );
    }
  }

  void _onCopyAddress(String address) async {
    await Clipboard.setData(
      ClipboardData(text: address),
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
