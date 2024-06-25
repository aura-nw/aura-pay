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
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/observers/recovery_observer.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_box_widget.dart';
import 'widgets/recovery_bottom_form_widget.dart';
import 'widgets/insufficient_amount_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_common/change_fee_form_widget.dart';
import 'recovery_method_confirmation_screen_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'recovery_method_confirmation_screen_bloc.dart';
import 'recovery_method_confirmation_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'widgets/recovery_message_widget.dart';

abstract class RecoveryMethodConfirmationArgument<T> {
  final AuraAccount account;
  final T? data;

  const RecoveryMethodConfirmationArgument({
    required this.account,
    required this.data,
  });
}

final class RecoveryMethodConfirmationGoogleArgument
    extends RecoveryMethodConfirmationArgument<GoogleAccount> {
  RecoveryMethodConfirmationGoogleArgument({
    required super.account,
    required super.data,
  });
}

final class RecoveryMethodConfirmationBackupAddressArgument
    extends RecoveryMethodConfirmationArgument<String> {
  RecoveryMethodConfirmationBackupAddressArgument({
    required super.account,
    required super.data,
  });
}

class RecoveryMethodConfirmationScreen extends StatefulWidget {
  final RecoveryMethodConfirmationArgument argument;

  const RecoveryMethodConfirmationScreen({
    required this.argument,
    super.key,
  });

  @override
  State<RecoveryMethodConfirmationScreen> createState() =>
      _RecoveryMethodConfirmationScreenState();
}

class _RecoveryMethodConfirmationScreenState
    extends State<RecoveryMethodConfirmationScreen> with CustomFlutterToast {
  late RecoveryMethodConfirmationBloc _bloc;

  final RecoveryObserver _recoveryObserver = getIt.get<RecoveryObserver>();

  final HomeScreenObserver _homeScreenObserver =
      getIt.get<HomeScreenObserver>();

  @override
  void initState() {
    _bloc = getIt.get<RecoveryMethodConfirmationBloc>(
      param1: widget.argument,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String recoverData =
        (widget.argument is RecoveryMethodConfirmationGoogleArgument)
            ? (widget.argument as RecoveryMethodConfirmationGoogleArgument)
                .data!
                .email
            : widget.argument.data;
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<RecoveryMethodConfirmationBloc,
              RecoveryMethodConfirmationState>(
            listener: (context, state) {
              switch (state.status) {
                case RecoveryMethodConfirmationStatus.none:
                  break;
                case RecoveryMethodConfirmationStatus.insufficientBalance:
                  AppNavigator.pop();

                  _showInsufficientDialog(appTheme);
                  break;
                case RecoveryMethodConfirmationStatus.onRecovering:
                  _showLoadingDialog(
                    appTheme,
                  );
                  break;
                case RecoveryMethodConfirmationStatus.onRecoverSuccess:
                  _homeScreenObserver.emit(
                    emitParam: HomeScreenEmitParam(
                      event:
                          HomeScreenObserver.onSetRecoveryMethodSuccessfulEvent,
                    ),
                  );
                  _recoveryObserver.emit(
                    emitParam: const RecoveryEmitParam(
                      status: true,
                    ),
                  );
                  AppNavigator.popUntil(
                    RoutePath.recoverMethod,
                  );
                  break;
                case RecoveryMethodConfirmationStatus.onRecoverFail:
                  AppNavigator.pop();
                  showToast(state.error ?? '');
                  break;
                case RecoveryMethodConfirmationStatus.onUnRegisterRecoverFail:
                  AppNavigator.pop();
                  showToast(state.error ?? '');
                  break;
              }
            },
            child: Scaffold(
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey:
                    LanguageKey.recoveryMethodConfirmationScreenAppBarTitle,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing07,
                    vertical: Spacing.spacing05,
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
                                    children: [
                                      TextSpan(
                                        text: localization.translate(
                                          LanguageKey
                                              .recoveryMethodConfirmationScreenContentRegionOne,
                                        ),
                                        style: AppTypoGraPhy.body03.copyWith(
                                          color: appTheme.contentColor700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' $recoverData ',
                                        style:
                                            AppTypoGraPhy.bodyMedium03.copyWith(
                                          color: appTheme.contentColorBlack,
                                        ),
                                      ),
                                      TextSpan(
                                        text: localization.translate(
                                          LanguageKey
                                              .recoveryMethodConfirmationScreenContentRegionTwo,
                                        ),
                                        style: AppTypoGraPhy.body03.copyWith(
                                          color: appTheme.contentColor700,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${widget.argument.account.address.addressView}',
                                        style:
                                            AppTypoGraPhy.bodyMedium03.copyWith(
                                          color: appTheme.contentColorBlack,
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
                            RecoveryMessageWidget(
                              appTheme: appTheme,
                              address: widget.argument.account.address,
                              onChangeViewData: _onChangeViewData,
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize06,
                            ),
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(
                                    LanguageKey
                                        .recoveryMethodConfirmationScreenMemo,
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
                              appTheme : appTheme,
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
                                            .recoveryMethodConfirmationScreenMemoHint,
                                      ),
                                      onChanged: (memo, _) {
                                        _bloc.add(
                                          RecoveryMethodConfirmationEventOnChangeMemo(
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
                      RecoveryBottomFormWidget(
                        appTheme: appTheme,
                        onEditFee: _onEditFee,
                        address: widget.argument.account.address,
                        accountName: widget.argument.account.name,
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
      const RecoveryMethodConfirmationEventOnChangeShowFullMsg(),
    );
  }

  void _onConfirm() {
    _bloc.add(
      const RecoveryMethodConfirmationEventOnConfirm(),
    );
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.recoveryMethodConfirmationScreenRecovering,
      ),
      appTheme: appTheme,
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
        RecoveryMethodConfirmationEventOnChangeFee(
          fee: fee.round().toString(),
        ),
      );
    }
  }

  void _showInsufficientDialog(AppTheme appTheme) {
    DialogProvider.showCustomDialog(
      context,
      appTheme: appTheme,
      widget: InsufficientAmountWidget(
        address: widget.argument.account.address,
        accountName: widget.argument.account.name,
        appTheme: appTheme,
        onCopy: _onCopy,
      ),
    );
  }

  void _onCopy(String address) async {
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
