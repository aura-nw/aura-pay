import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction_confirmation/widgets/change_fee_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'send_transaction_confirmation_selector.dart';
import 'send_transaction_confirmation_event.dart';
import 'send_transaction_confirmation_state.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'send_transaction_confirmation_bloc.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';

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

  @override
  void initState() {
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
              body: Padding(
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
                          const SizedBox(
                            height: BoxSize.boxSize04,
                          ),
                          SvgPicture.asset(
                            AssetIconPath.sendConfirmation,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize06,
                          ),
                          _buildInformation(
                            LanguageKey
                                .sendTransactionConfirmationScreenSendFrom,
                            '${widget.sender.address.addressView} (${widget.sender.name})',
                            appTheme,
                          ),
                          _buildInformation(
                            LanguageKey
                                .sendTransactionConfirmationScreenRecipient,
                            widget.recipient.addressView,
                            appTheme,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return _buildInformation(
                                LanguageKey
                                    .sendTransactionConfirmationScreenAmount,
                                '${widget.amount} ${localization.translate(
                                  LanguageKey.globalPyxisAura,
                                )}',
                                appTheme,
                              );
                            },
                          ),
                          _buildTransactionFee(
                            appTheme,
                          ),
                          const DividerSeparator(),
                          const SizedBox(
                            height: BoxSize.boxSize06,
                          ),
                          _buildTotal(
                            appTheme,
                          ),
                        ],
                      ),
                    ),
                    _buildBottom(
                      appTheme,
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

  Widget _buildInformation(String titleKey, String value, AppTheme appTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  titleKey,
                ),
                style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          Text(
            value,
            style: AppTypoGraPhy.body03.copyWith(
              color: appTheme.contentColorBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionFee(
    AppTheme appTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.sendTransactionConfirmationScreenFee,
                ),
                style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          Row(
            children: [
              AppLocalizationProvider(
                builder: (localization, _) {
                  return SendTransactionConfirmationFeeSelector(builder: (fee) {
                    return Text(
                      '${fee.formatAura} ${localization.translate(
                        LanguageKey.globalPyxisAura,
                      )}',
                      style: AppTypoGraPhy.body03.copyWith(
                        color: appTheme.contentColorBlack,
                      ),
                    );
                  });
                },
              ),
              const SizedBox(
                width: BoxSize.boxSize04,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _onEditFee,
                child: SvgPicture.asset(
                  AssetIconPath.sendConfirmationEdit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotal(AppTheme appTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Spacing.spacing06,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppLocalizationProvider(
            builder: (localization, _) {
              return Text(
                localization.translate(
                  LanguageKey.sendTransactionConfirmationScreenTotal,
                ),
                style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                  color: appTheme.contentColorBlack,
                ),
              );
            },
          ),
          AppLocalizationProvider(
            builder: (localization, _) {
              return SendTransactionConfirmationAmountSelector(
                builder: (amount) {
                  double amountD = double.tryParse(amount) ?? 0;
                  return SendTransactionConfirmationFeeSelector(
                    builder: (fee) {
                      double feeD = double.tryParse(fee.formatAura) ?? 0;
                      return Text(
                        '${amountD + feeD} ${localization.translate(
                          LanguageKey.globalPyxisAura,
                        )}',
                        style: AppTypoGraPhy.heading03.copyWith(
                          color: appTheme.contentColorBrand,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(
    AppTheme appTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AssetIconPath.sendConfirmationDivider,
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
              AssetIconPath.sendConfirmationMessage,
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
