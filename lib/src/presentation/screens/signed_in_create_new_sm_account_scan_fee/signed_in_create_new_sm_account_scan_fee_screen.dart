import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'signed_in_create_new_sm_account_scan_fee_bloc.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/qr_code_widget.dart';

import 'signed_in_create_new_sm_account_scan_fee_event.dart';
import 'signed_in_create_new_sm_account_scan_fee_state.dart';

class SignedInCreateNewSmAccountScanFeeScreen extends StatefulWidget {
  final String rawAddress;
  final String accountName;
  final Uint8List privateKey;
  final Uint8List salt;

  const SignedInCreateNewSmAccountScanFeeScreen({
    required this.rawAddress,
    required this.accountName,
    required this.privateKey,
    required this.salt,
    super.key,
  });

  @override
  State<SignedInCreateNewSmAccountScanFeeScreen> createState() =>
      _SignedInCreateNewSmAccountScanFeeScreenState();
}

class _SignedInCreateNewSmAccountScanFeeScreenState
    extends State<SignedInCreateNewSmAccountScanFeeScreen>
    with CustomFlutterToast {
  late SignedInCreateNewSmAccountScanFeeBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get<SignedInCreateNewSmAccountScanFeeBloc>(
      param1: <String, String>{
        'smartAccountAddress': widget.rawAddress,
        'accountName': widget.accountName,
      },
      param2: <String, Uint8List>{
        'privateKey': widget.privateKey,
        'salt': widget.salt,
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<SignedInCreateNewSmAccountScanFeeBloc,
              SignedInCreateNewSmAccountScanFeeState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInCreateNewSmAccountScanFeeStatus.init:
                  break;
                case SignedInCreateNewSmAccountScanFeeStatus.onCheckBalance:
                  _showLoadingDialog(appTheme);
                  break;
                case SignedInCreateNewSmAccountScanFeeStatus
                      .onCheckBalanceUnEnough:
                  _showWarningDialog(appTheme);
                  break;
                case SignedInCreateNewSmAccountScanFeeStatus
                      .onCheckBalanceError:
                  showToast(state.errorMessage!);
                  break;
                case SignedInCreateNewSmAccountScanFeeStatus.onActiveAccount:
                  AppNavigator.pop();
                  _showLoadingDialog(appTheme);
                  break;
                case SignedInCreateNewSmAccountScanFeeStatus
                      .onActiveAccountError:
                  AppNavigator.pop();
                  showToast(state.errorMessage!);
                  break;
                case SignedInCreateNewSmAccountScanFeeStatus
                      .onActiveAccountSuccess:
                  AppGlobalCubit.of(context).addNewAccount(
                    GlobalActiveAccount(
                      address: state.smartAccountAddress,
                      accountName: state.accountName,
                    ),
                  );
                  AppNavigator.popUntil(
                    RoutePath.home,
                  );
                  break;
              }
            },
            child: Scaffold(
              appBar: AppBarStepWidget(
                appTheme: appTheme,
                onViewMoreInformationTap: () {},
                currentStep: 1,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing08,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return RichText(
                                text: TextSpan(
                                  style: AppTypoGraPhy.heading06.copyWith(
                                      color: appTheme.contentColorBlack),
                                  children: [
                                    TextSpan(
                                      text: localization.translate(
                                        LanguageKey
                                            .signedInScanFeeScreenTitleRegionOne,
                                      ),
                                      style: AppTypoGraPhy.heading06.copyWith(
                                        color: appTheme.contentColorBrand,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .signedInScanFeeScreenTitleRegionTwo,
                                      )}',
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
                              return RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: localization.translate(
                                        LanguageKey
                                            .signedInScanFeeScreenContentRegionOne,
                                      ),
                                      style:
                                          AppTypoGraPhy.bodyMedium03.copyWith(
                                        color: appTheme.contentColor500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .signedInScanFeeScreenContentRegionTwo,
                                      )}',
                                      style:
                                          AppTypoGraPhy.bodyMedium03.copyWith(
                                        color: appTheme.contentColorBrand,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .signedInScanFeeScreenContentRegionThree,
                                      )}',
                                      style:
                                          AppTypoGraPhy.bodyMedium03.copyWith(
                                        color: appTheme.contentColor500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize07,
                          ),
                          QrCodeWidget(
                            rawData: widget.rawAddress,
                            appTheme: appTheme,
                          ),
                        ],
                      ),
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) => PrimaryAppButton(
                        text: localization.translate(
                          LanguageKey.signedInScanFeeScreenButtonTitle,
                        ),
                        onPress: () {
                          _bloc.add(
                            const SignedInCreateNewSmAccountScanFeeOnCheckingBalanceEvent(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.instance
          .translate(LanguageKey.signedInScanFeeScreenDialogLoadingContent),
      appTheme: appTheme,
    );
  }

  void _showWarningDialog(AppTheme appTheme) {
    DialogProvider.showWarningDialog(
      context,
      title: AppLocalizationManager.instance.translate(
        LanguageKey.signedInScanFeeScreenDialogWarningTitle,
      ),
      message: AppLocalizationManager.instance.translate(
        LanguageKey.signedInScanFeeScreenDialogWarningContent,
      ),
      buttonTitle: AppLocalizationManager.instance.translate(
        LanguageKey.signedInScanFeeScreenDialogWarningButtonTitle,
      ),
      onButtonTap: () => AppNavigator.pop(),
      appTheme: appTheme,
    );
  }
}
