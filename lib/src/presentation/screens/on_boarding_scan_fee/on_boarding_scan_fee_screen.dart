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
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/qr_code_widget.dart';

import 'on_boarding_scan_fee_bloc.dart';
import 'on_boarding_scan_fee_event.dart';
import 'on_boarding_scan_fee_state.dart';

class OnBoardingScanFeeScreen extends StatefulWidget {
  final String rawAddress;
  final String accountName;
  final Uint8List privateKey;
  final Uint8List salt;

  const OnBoardingScanFeeScreen({
    required this.rawAddress,
    required this.accountName,
    required this.privateKey,
    required this.salt,
    super.key,
  });

  @override
  State<OnBoardingScanFeeScreen> createState() =>
      _OnBoardingScanFeeScreenState();
}

class _OnBoardingScanFeeScreenState extends State<OnBoardingScanFeeScreen>
    with CustomFlutterToast {
  late OnBoardingScanFeeBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get<OnBoardingScanFeeBloc>(
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
          child: BlocListener<OnBoardingScanFeeBloc, OnBoardingScanFeeState>(
            listener: (context, state) {
              switch (state.status) {
                case OnBoardingScanFeeStatus.init:
                  break;
                case OnBoardingScanFeeStatus.onCheckBalance:
                  _showLoadingDialog(appTheme);
                  break;
                case OnBoardingScanFeeStatus.onCheckBalanceUnEnough:
                  _showWarningDialog(appTheme);
                  break;
                case OnBoardingScanFeeStatus.onCheckBalanceError:
                  showToast(state.errorMessage!);
                  break;
                case OnBoardingScanFeeStatus.onActiveAccount:
                  AppNavigator.pop();
                  _showLoadingDialog(appTheme);
                  break;
                case OnBoardingScanFeeStatus.onActiveAccountError:
                  AppNavigator.pop();
                  showToast(state.errorMessage!);
                  break;
                case OnBoardingScanFeeStatus.onActiveAccountSuccess:
                  AppGlobalCubit.of(context).changeState(
                    const AppGlobalState(
                      status: AppGlobalStatus.authorized,
                      onBoardingStatus: OnBoardingStatus.createSmAccountSuccess,
                    ),
                  );

                  AppNavigator.pop();
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
                                            .onBoardingScanFeeScreenTitleRegionOne,
                                      ),
                                      style: AppTypoGraPhy.heading06.copyWith(
                                        color: appTheme.contentColorBrand,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .onBoardingScanFeeScreenTitleRegionTwo,
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
                                            .onBoardingScanFeeScreenContentRegionOne,
                                      ),
                                      style:
                                          AppTypoGraPhy.bodyMedium03.copyWith(
                                        color: appTheme.contentColor500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .onBoardingScanFeeScreenContentRegionTwo,
                                      )}',
                                      style:
                                          AppTypoGraPhy.bodyMedium03.copyWith(
                                        color: appTheme.contentColorBrand,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .onBoardingScanFeeScreenContentRegionThree,
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
                          LanguageKey.onBoardingScanFeeScreenButtonTitle,
                        ),
                        onPress: () {
                          _bloc.add(
                            const OnBoardingScanFeeOnCheckingBalanceEvent(),
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
      content: AppLocalizationManager.of(context)
          .translate(LanguageKey.onBoardingScanFeeScreenDialogLoadingContent),
      appTheme: appTheme,
    );
  }

  void _showWarningDialog(AppTheme appTheme) {
    DialogProvider.showWarningDialog(
      context,
      title: AppLocalizationManager.of(context).translate(
        LanguageKey.onBoardingScanFeeScreenDialogWarningTitle,
      ),
      message: AppLocalizationManager.of(context).translate(
        LanguageKey.onBoardingScanFeeScreenDialogWarningContent,
      ),
      buttonTitle: AppLocalizationManager.of(context).translate(
        LanguageKey.onBoardingScanFeeScreenDialogWarningButtonTitle,
      ),
      onButtonTap: () => AppNavigator.pop(),
      appTheme: appTheme,
    );
  }
}
