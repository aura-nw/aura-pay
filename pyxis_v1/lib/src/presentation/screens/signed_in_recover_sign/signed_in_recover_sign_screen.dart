import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_box_widget.dart';
import 'signed_in_recover_sign_bloc.dart';
import 'signed_in_recover_sign_event.dart';
import 'signed_in_recover_sign_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_common/change_fee_form_widget.dart';

import 'widgets/signed_in_recovery_bottom_form_widget.dart';
import 'widgets/signed_in_recovery_message_form_widget.dart';

class SignedInRecoverSignScreen extends StatefulWidget {
  final PyxisRecoveryAccount account;
  final GoogleAccount googleAccount;

  const SignedInRecoverSignScreen({
    super.key,
    required this.googleAccount,
    required this.account,
  });

  @override
  State<SignedInRecoverSignScreen> createState() =>
      _SignedInRecoverSignScreenState();
}

class _SignedInRecoverSignScreenState extends State<SignedInRecoverSignScreen>
    with CustomFlutterToast {
  late SignedInRecoverSignBloc _bloc;

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  @override
  void initState() {
    _bloc = getIt.get<SignedInRecoverSignBloc>(
      param1: widget.account,
      param2: widget.googleAccount,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child:
              BlocListener<SignedInRecoverSignBloc, SignedInRecoverSignState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInRecoverSignStatus.none:
                  break;
                case SignedInRecoverSignStatus.onRecovering:
                  _showLoadingDialog(appTheme);
                  break;
                case SignedInRecoverSignStatus.onRecoverFail:
                  showToast(
                    state.error ?? '',
                  );
                  AppNavigator.pop();
                  break;
                case SignedInRecoverSignStatus.onRecoverSuccess:
                  _observer.emit(
                    emitParam: HomeScreenEmitParam(
                      event: HomeScreenObserver.onAddNewAccountSuccessfulEvent,
                    ),
                  );
                  AppNavigator.popUntil(
                    RoutePath.accounts,
                  );
                  break;
              }
            },
            child: Scaffold(
              appBar: NormalAppBarWidget(
                onViewMoreInformationTap: () {},
                appTheme: appTheme,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing07,
                    vertical: Spacing.spacing05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: localization.translate(
                                          LanguageKey
                                              .signedInRecoverSignScreenTitleRegionOne,
                                        ),
                                        style: AppTypoGraPhy.heading06.copyWith(
                                          color: appTheme.contentColorBlack,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${localization.translate(
                                          LanguageKey
                                              .signedInRecoverSignScreenTitleRegionTwo,
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
                              height: BoxSize.boxSize06,
                            ),
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(
                                    localization.translate(
                                      LanguageKey
                                          .signedInRecoverSignScreenContent,
                                    ),
                                  ),
                                  style: AppTypoGraPhy.body03.copyWith(
                                    color: appTheme.contentColor500,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize06,
                            ),
                            SignedInRecoveryMessageWidget(
                              appTheme: appTheme,
                              newAddress: widget.googleAccount.email,
                              address: widget.account.smartAccountAddress,
                              onChangeViewData: _onChangeViewData,
                            ),
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(
                                    LanguageKey.signedInRecoverSignScreenMemo,
                                  ),
                                  style: AppTypoGraPhy.utilityLabelDefault
                                      .copyWith(
                                    color: appTheme.contentColorBlack,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize03,
                            ),
                            ScrollBarWidget(
                              appTheme: appTheme,
                              child: TransactionBoxWidget(
                                appTheme: appTheme,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.spacing03,
                                ),
                                child: AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return TextInputOnlyTextFieldWidget(
                                      boxConstraints: const BoxConstraints(
                                        maxHeight: BoxSize.boxSize12,
                                      ),
                                      hintText: localization.translate(
                                        LanguageKey
                                            .signedInRecoverSignScreenMemoHint,
                                      ),
                                      onChanged: (memo, _) {
                                        _bloc.add(
                                          SignedInRecoverSignEventOnChangeMemo(
                                            memo: memo,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SignedInRecoveryBottomFormWidget(
                        appTheme: appTheme,
                        onEditFee: _onEditFee,
                        address: widget.account.smartAccountAddress,
                        accountName:
                            widget.account.name ?? PyxisAccountConstant.unName,
                        onConfirm: _onConfirm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onChangeViewData() {
    _bloc.add(
      const SignedInRecoverSignEventOnChangeShowFullMsg(),
    );
  }

  void _onConfirm() {
    _bloc.add(
      const SignedInRecoverSignEventOnConfirm(),
    );
  }

  void _onEditFee() async {
    final fee = await AppBottomSheetLayout.showFullScreenDialog(
      context,
      child: ChangeFeeFormWidget(
        max: double.parse(
          _bloc.state.highTransactionFee,
        ),
        min: double.parse(
          _bloc.state.lowTransactionFee,
        ),
        currentValue: double.parse(
          _bloc.state.transactionFee,
        ),
      ),
    );

    if (fee is double) {
      _bloc.add(
        SignedInRecoverSignEventOnChangeFee(
          fee: fee.round().toString(),
        ),
      );
    }
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.signedInRecoverSignScreenRecovering,
      ),
      appTheme: appTheme,
    );
  }
}
