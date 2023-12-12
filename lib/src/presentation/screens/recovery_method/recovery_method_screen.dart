import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/recovery_method/widgets/recovery_account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
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

class _RecoveryMethodScreenState extends State<RecoveryMethodScreen> {
  final RecoveryMethodScreenBloc _bloc = getIt.get<RecoveryMethodScreenBloc>();

  @override
  void initState() {
    _bloc.add(
      const RecoveryMethodScreenEventFetchAccount(),
    );
    super.initState();
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

                                    String? recoveryType;
                                    String? recoveryMethod;

                                    if (account.isVerified) {
                                      recoveryType = account.method?.method ==
                                              AuraSmartAccountRecoveryMethod
                                                  .web3Auth
                                          ? LanguageKey.recoveryMethodScreenGoogle
                                          : LanguageKey
                                              .recoveryMethodScreenBackupAddress;

                                      recoveryMethod =
                                          '${AppLocalizationManager.of(context).translate(
                                        recoveryType,
                                      )} ${account.method?.value}';
                                    }

                                    return AccountRecoveryWidget(
                                      accountName: account.name,
                                      address: account.address,
                                      isVerified: account.isVerified,
                                      appTheme: appTheme,
                                      recoveryMethod: recoveryMethod,
                                      onTap: () async {
                                        if (!account.isVerified) {
                                          await AppNavigator.push(
                                            RoutePath.setRecoverMethod,
                                            account,
                                          );
                                        }
                                      },
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
}
