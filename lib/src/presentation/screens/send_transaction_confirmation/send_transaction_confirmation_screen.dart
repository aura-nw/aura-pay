import 'package:aura_smart_account/aura_smart_account.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/json_formatter.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_box_widget.dart';
import 'widgets/transaction_information_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_common/change_fee_form_widget.dart';
import 'send_transaction_confirmation_selector.dart';
import 'send_transaction_confirmation_event.dart';
import 'send_transaction_confirmation_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'send_transaction_confirmation_bloc.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class SendTransactionConfirmationScreen extends StatefulWidget {
  final AuraAccount sender;
  final String recipient;
  final String amount;
  final String transactionFee;
  final int gasEstimation;

  const SendTransactionConfirmationScreen({
    super.key,
    required this.amount,
    required this.recipient,
    required this.sender,
    required this.transactionFee,
    required this.gasEstimation,
  });

  @override
  State<SendTransactionConfirmationScreen> createState() =>
      _SendTransactionConfirmationScreenState();
}

class _SendTransactionConfirmationScreenState
    extends State<SendTransactionConfirmationScreen> with CustomFlutterToast {
  late SendTransactionConfirmationBloc _bloc;

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  void _emitSendTransactionSuccessFul() {
    _observer.emit(
      emitParam: HomeScreenEmitParam(
        event: HomeScreenObserver.onSendTokenSuccessFulEvent,
      ),
    );
  }

  final config = getIt.get<PyxisMobileConfig>();

  late MsgSend msgSend;

  void _createMsgSend() {
    msgSend = MsgSend.create()
      ..fromAddress = widget.sender.address
      ..toAddress = widget.recipient
      ..amount.add(
        Coin.create()
          ..amount = widget.amount.toDenom
          ..denom = config.deNom,
      );
  }

  @override
  void initState() {
    _createMsgSend();
    _bloc = getIt.get<SendTransactionConfirmationBloc>(
      param1: widget.sender,
      param2: {
        'recipient': widget.recipient,
        'amount': widget.amount,
        'fee': widget.transactionFee,
        'gas': widget.gasEstimation,
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
          child: BlocListener<SendTransactionConfirmationBloc,
              SendTransactionConfirmationState>(
            listener: (context, state) {
              switch (state.status) {
                case SendTransactionConfirmationStatus.none:
                  break;
                case SendTransactionConfirmationStatus.loading:
                  _showLoadingDialog(appTheme);
                  break;
                case SendTransactionConfirmationStatus.error:
                  showToast(state.errorMsg!);
                  AppNavigator.pop();
                  break;
                case SendTransactionConfirmationStatus.success:
                  AppNavigator.pop();

                  _emitSendTransactionSuccessFul();

                  AppNavigator.push(
                    RoutePath.sendTransactionSuccessFul,
                    {
                      'sender': state.sender.address,
                      'amount': state.amount,
                      'recipient': state.recipient,
                      'hash': state.transactionInformation?.txHash ?? '',
                      'time': state.transactionInformation?.timestamp ?? '',
                    },
                  );
                  break;
              }
            },
            child: Scaffold(
              backgroundColor: appTheme.bodyColorBackground,
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey:
                    LanguageKey.sendTransactionConfirmationScreenAppBarTitle,
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
                            Row(
                              children: [
                                AppLocalizationProvider(
                                  builder: (localization, p1) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey
                                            .sendTransactionConfirmationScreenMessages,
                                      ),
                                      style: AppTypoGraPhy.utilityLabelDefault
                                          .copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize03,
                            ),
                            TransactionBoxWidget(
                              appTheme: appTheme,
                              child:
                              // Text(
                              //   prettyJson(
                              //     msgSend.toProto3Json()
                              //         as Map<String, dynamic>,
                              //   ),
                              // ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AssetIconPath.commonSignMessage,
                                  ),
                                  const SizedBox(
                                    width: BoxSize.boxSize04,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppLocalizationProvider(
                                          builder: (localization, _) {
                                            return Text(
                                              localization.translate(
                                                LanguageKey
                                                    .sendTransactionConfirmationScreenSend,
                                              ),
                                              style: AppTypoGraPhy
                                                  .utilityLabelDefault
                                                  .copyWith(
                                                color:
                                                    appTheme.contentColorBlack,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(),
                                        AppLocalizationProvider(
                                          builder: (localization, p1) {
                                            return Text(
                                              localization.translateWithParam(
                                                LanguageKey
                                                    .sendTransactionConfirmationScreenContent,
                                                {
                                                  'amount': widget.amount,
                                                  'token_name':
                                                      localization.translate(
                                                    LanguageKey.globalPyxisAura,
                                                  ),
                                                  'address': widget
                                                      .recipient.addressView,
                                                },
                                              ),
                                              style: AppTypoGraPhy
                                                  .utilityLabelDefault
                                                  .copyWith(
                                                color:
                                                    appTheme.contentColorBlack,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize06,
                            ),
                            Row(
                              children: [
                                AppLocalizationProvider(
                                  builder: (localization, p1) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey
                                            .sendTransactionConfirmationScreenMemo,
                                      ),
                                      style: AppTypoGraPhy.utilityLabelDefault
                                          .copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize03,
                            ),
                            TransactionBoxWidget(
                              appTheme: appTheme,
                              child: AppLocalizationProvider(
                                builder: (localization, _) {
                                  return TextInputOnlyTextFieldWidget(
                                    hintText: localization.translate(
                                      LanguageKey
                                          .sendTransactionConfirmationScreenMemoHint,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize06,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        AssetIconPath.commonTransactionDivider,
                      ),
                      TransactionInformationWidget(
                        accountName: widget.sender.name,
                        amount: widget.amount,
                        from: widget.sender.address,
                        recipient: widget.recipient,
                        appTheme: appTheme,
                        onEditFee: _onEditFee,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize05,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return PrimaryAppButton(
                            text: localization.translate(
                              LanguageKey.sendTransactionConfirmationScreenSend,
                            ),
                            onPress: () {
                              _bloc.add(
                                const SendTransactionConfirmationEventOnSendToken(),
                              );
                            },
                          );
                        },
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

  Widget _buildBottom(
    AppTheme appTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AssetIconPath.commonTransactionDivider,
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        AppLocalizationProvider(
          builder: (localization, p1) {
            return Text(
              localization.translate(
                LanguageKey.sendTransactionConfirmationScreenMessages,
              ),
              style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                color: appTheme.contentColorBlack,
              ),
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize04,
        ),
        Row(
          children: [
            SvgPicture.asset(
              AssetIconPath.commonSignMessage,
            ),
            const SizedBox(
              width: BoxSize.boxSize04,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppLocalizationProvider(
                    builder: (localization, _) {
                      return Text(
                        localization.translate(
                          LanguageKey.sendTransactionConfirmationScreenSend,
                        ),
                        style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                      );
                    },
                  ),
                  const SizedBox(),
                  AppLocalizationProvider(
                    builder: (localization, p1) {
                      return Text(
                        localization.translateWithParam(
                          LanguageKey.sendTransactionConfirmationScreenContent,
                          {
                            'amount': widget.amount,
                            'token_name': localization.translate(
                              LanguageKey.globalPyxisAura,
                            ),
                            'address': widget.recipient.addressView,
                          },
                        ),
                        style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                          color: appTheme.contentColorBlack,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: BoxSize.boxSize07,
        ),
        AppLocalizationProvider(
          builder: (localization, _) {
            return PrimaryAppButton(
              text: localization.translate(
                LanguageKey.sendTransactionConfirmationScreenSend,
              ),
              onPress: () {
                _bloc.add(
                  const SendTransactionConfirmationEventOnSendToken(),
                );
              },
            );
          },
        ),
        const SizedBox(
          height: BoxSize.boxSize08,
        ),
      ],
    );
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.sendTransactionConfirmationScreenSending,
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
        SendTransactionConfirmationEventOnChangeFee(
          fee: fee.round().toString(),
        ),
      );
    }
  }
}
