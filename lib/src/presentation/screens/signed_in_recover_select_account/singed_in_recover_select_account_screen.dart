import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'signed_in_recover_select_account_bloc.dart';
import 'singed_in_recover_select_account_event.dart';
import 'singed_in_recover_select_account_selector.dart';
import 'singed_in_recover_select_account_state.dart';
import 'widgets/smart_account_widget.dart';

class SingedInRecoverSelectAccountScreen extends StatefulWidget {
  final GoogleAccount googleAccount;

  const SingedInRecoverSelectAccountScreen({
    required this.googleAccount,
    super.key,
  });

  @override
  State<SingedInRecoverSelectAccountScreen> createState() =>
      _SingedInRecoverSelectAccountScreenState();
}

class _SingedInRecoverSelectAccountScreenState
    extends State<SingedInRecoverSelectAccountScreen> {
  late SingedInRecoverSelectAccountBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get<SingedInRecoverSelectAccountBloc>(
      param1: widget.googleAccount,
    )..add(
        const SingedInRecoverSelectAccountEventFetchAccount(),
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
            appBar: NormalAppBarWidget(
              onViewMoreInformationTap: () {},
              appTheme: appTheme,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing07,
                vertical: Spacing.spacing08,
              ),
              child: SingedInRecoverSelectAccountStatusSelector(
                builder: (status) {
                  switch (status) {
                    case SingedInRecoverSelectAccountStatus.loading:
                      return Center(
                        child: AppLoadingWidget(
                          appTheme: appTheme,
                        ),
                      );
                    case SingedInRecoverSelectAccountStatus.loaded:
                    case SingedInRecoverSelectAccountStatus.error:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: localization.translate(
                                        LanguageKey
                                            .signedInRecoverSelectAccountScreenTitleRegionOne,
                                      ),
                                      style: AppTypoGraPhy.heading06.copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .signedInRecoverSelectAccountScreenTitleRegionTwo,
                                      )}',
                                      style: AppTypoGraPhy.heading05.copyWith(
                                        color: appTheme.contentColorBrand,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize05,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translate(
                                  LanguageKey
                                      .signedInRecoverSelectAccountScreenContent,
                                ),
                                style: AppTypoGraPhy.body03.copyWith(
                                  color: appTheme.contentColor500,
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: SignedInRecoverSelectAccountAccountsSelector(
                              builder: (accounts) {
                                if (accounts.isEmpty) {
                                  return Center(
                                    child: AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return Text(
                                          localization.translate(
                                            LanguageKey
                                                .signedInRecoverSelectAccountScreenNoAccountFound,
                                          ),
                                          style: AppTypoGraPhy.bodyMedium02
                                              .copyWith(
                                            color: appTheme.contentColor500,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Spacing.spacing07,
                                  ),
                                  reverse: true,
                                  itemCount: accounts.length,
                                  itemBuilder: (context, index) {
                                    final account = accounts[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: Spacing.spacing05,
                                      ),
                                      child:
                                          SignedInRecoverSelectAccountAccountSelectedSelector(
                                        builder: (selectedAccount) {
                                          return SmartAccountWidget(
                                            appTheme: appTheme,
                                            smartAccountAddress:
                                                account.address.addressView,
                                            smartAccountName: account.name,
                                            onTap: () {
                                              _bloc.add(
                                                SingedInRecoverSelectAccountEventSelectAccount(
                                                  account: account,
                                                ),
                                              );
                                            },
                                            isSelected: selectedAccount?.id ==
                                                account.id,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return SignedInRecoverSelectAccountAccountSelectedSelector(
                                builder: (account) {
                                  return PrimaryAppButton(
                                    text: localization.translate(
                                      LanguageKey
                                          .signedInRecoverSelectAccountScreenButtonTitle,
                                    ),
                                    isDisable: account == null,
                                    onPress: () {
                                      AppNavigator.push(
                                        RoutePath.recoverSign,
                                        {
                                          'account': account,
                                          'google_account':
                                              widget.googleAccount,
                                        },
                                      );

                                      // AppNavigator.push(
                                      //   RoutePath.recoverReviewing,
                                      // );
                                    },
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
