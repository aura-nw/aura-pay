import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/wallet_address_validator.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction/widgets/text_input_recipient_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'send_transaction_bloc.dart';
import 'send_transaction_event.dart';
import 'send_transaction_selector.dart';
import 'widgets/sender_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

import 'send_transaction_state.dart';

class SendTransactionScreen extends StatefulWidget {
  const SendTransactionScreen({super.key});

  @override
  State<SendTransactionScreen> createState() => _SendTransactionScreenState();
}

class _SendTransactionScreenState extends State<SendTransactionScreen> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final SendTransactionBloc _bloc = getIt.get<SendTransactionBloc>();

  @override
  void initState() {
    _bloc.add(
      const SendTransactionEventOnInit(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<SendTransactionBloc, SendTransactionState>(
            listener: (context, state) {},
            child: Scaffold(
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey: LanguageKey.sendTransactionAppBarTitle,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing05,
                ),
                child: SendTransactionStatusSelector(builder: (status) {
                  switch (status) {
                    case SendTransactionStatus.loading:
                    case SendTransactionStatus.error:
                      return Center(
                        child: AppLoadingWidget(
                          appTheme: appTheme,
                        ),
                      );
                    case SendTransactionStatus.loaded:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey.sendTransactionSendFrom,
                                      ),
                                      style: AppTypoGraPhy.utilityLabelDefault
                                          .copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: BoxSize.boxSize04,
                                ),
                                SendTransactionSenderSelector(
                                  builder: (sender) {
                                    return SenderWidget(
                                      appTheme: appTheme,
                                      address: sender?.address ?? '',
                                      accountName: sender?.name ?? '',
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: BoxSize.boxSize07,
                                ),
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey
                                            .sendTransactionRecipientLabel,
                                      ),
                                      style: AppTypoGraPhy.utilityLabelDefault
                                          .copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    );
                                  },
                                ),
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return TextInputRecipientWidget(
                                      hintText: localization.translate(
                                        LanguageKey
                                            .sendTransactionRecipientHint,
                                      ),
                                      controller: _recipientController,
                                      onClear: _onClearRecipient,
                                      onChanged: _onChangeRecipientData,
                                      onQrTap: () {},
                                      onPaste: _onGetClipBoardData,
                                      constraintManager: ConstraintManager()
                                        ..custom(
                                          errorMessage: localization.translate(
                                            LanguageKey
                                                .sendTransactionRecipientInValid,
                                          ),
                                          customValid: (recipient) {
                                            return WalletAddressValidator
                                                .isValidAddress(recipient);
                                          },
                                        ),
                                      // constraintManager: ConstraintManager(),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: BoxSize.boxSize07,
                                ),
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey.sendTransactionAmount,
                                      ),
                                      style: AppTypoGraPhy.utilityLabelDefault
                                          .copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: BoxSize.boxSize05,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(
                                        Spacing.spacing03,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          BorderRadiusSize.borderRadiusRound,
                                        ),
                                        color: appTheme.surfaceColorGrayLight,
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            AssetIconPath.sendAuraCoin,
                                          ),
                                          const SizedBox(
                                            width: BoxSize.boxSize04,
                                          ),
                                          AppLocalizationProvider(
                                            builder: (localization, _) {
                                              return Text(
                                                localization.translate(
                                                  LanguageKey.globalPyxisAura,
                                                ),
                                                style: AppTypoGraPhy
                                                    .bodyMedium03
                                                    .copyWith(
                                                  color: appTheme
                                                      .contentColorBlack,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return SendTransactionBalanceSelector(
                                          builder: (balance) {
                                            return Text(
                                              '${localization.translate(
                                                LanguageKey
                                                    .sendTransactionBalance,
                                              )}: $balance ${localization.translate(
                                                LanguageKey.globalPyxisAura,
                                              )}',
                                              style: AppTypoGraPhy.bodyMedium02
                                                  .copyWith(
                                                color: appTheme.contentColor500,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return TextInputNormalSuffixWidget(
                                      hintText: localization.translate(
                                        LanguageKey.sendTransactionBalanceHint,
                                      ),
                                      onChanged: _onChangeAmount,
                                      controller: _amountController,
                                      suffix: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => _onChangeAmount(
                                          _bloc.state.balance,
                                          true,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            Spacing.spacing03,
                                          ),
                                          child: Text(
                                            localization.translate(
                                              LanguageKey
                                                  .sendTransactionAmountMax,
                                            ),
                                            style: AppTypoGraPhy.bodyMedium03
                                                .copyWith(
                                                    color: appTheme
                                                        .contentColorBrand),
                                          ),
                                        ),
                                      ),
                                      constraintManager: ConstraintManager()
                                        ..custom(
                                            errorMessage:
                                                localization.translate(
                                              LanguageKey
                                                  .sendTransactionAmountInValid,
                                            ),
                                            customValid: _checkValidAmount),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return SendTransactionIsReadySubmitSelector(
                                builder: (isReadySubmit) {
                                  return PrimaryAppButton(
                                    text: localization.translate(
                                      LanguageKey
                                          .sendTransactionButtonNextTitle,
                                    ),
                                    isDisable: !isReadySubmit,
                                    onPress: () async {

                                    },
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
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onGetClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    _onChangeRecipientData(
      data?.text ?? '',
      true,
    );
  }

  void _onChangeRecipientData(String value, bool isValid) async {
    _recipientController.text = value;

    _bloc.add(
      SendTransactionEventOnChangeRecipientAddress(
        _recipientController.text.trim(),
      ),
    );
  }

  void _onClearRecipient() {
    _recipientController.text = '';

    _bloc.add(
      SendTransactionEventOnChangeRecipientAddress(
        _recipientController.text.trim(),
      ),
    );
  }

  void _onChangeAmount(String amount, bool isValid) {
    _amountController.text = amount;

    _bloc.add(
      SendTransactionEvent.onChangeAmount(
        _amountController.text.trim(),
      ),
    );
  }

  bool _checkValidAmount(amount) {
    try {
      double am = double.parse(amount);

      return am > 0;
    } catch (e) {
      return false;
    }
  }
}
