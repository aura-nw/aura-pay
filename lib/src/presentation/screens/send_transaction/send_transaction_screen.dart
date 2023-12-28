// Importing necessary packages and dependencies
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

// Importing dependencies from the project
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
import 'package:pyxis_mobile/src/core/helpers/system_permission_helper.dart';
import 'package:pyxis_mobile/src/core/helpers/wallet_address_validator.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction/widgets/text_input_recipient_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';

// Importing Bloc and related files
import 'send_transaction_bloc.dart';
import 'send_transaction_event.dart';
import 'send_transaction_selector.dart';
import 'widgets/sender_widget.dart';

// Importing additional widgets
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

// Importing the state file
import 'send_transaction_state.dart';

// The main widget for the SendTransactionScreen
class SendTransactionScreen extends StatefulWidget {
  const SendTransactionScreen({super.key});

  @override
  State<SendTransactionScreen> createState() => _SendTransactionScreenState();
}

// State class for the SendTransactionScreen
class _SendTransactionScreenState extends State<SendTransactionScreen>
    with CustomFlutterToast {
  // Text editing controllers for recipient address and amount
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  // Instance of SendTransactionBloc for state management
  final SendTransactionBloc _bloc = getIt.get<SendTransactionBloc>();

  @override
  void initState() {
    // Adding the initial event to the bloc when the screen is initialized
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
            listener: (context, state) {
              // Switching based on the state status
              switch (state.status) {
                case SendTransactionStatus.loading:
                  // Handling loading state
                  break;
                case SendTransactionStatus.loaded:
                  // Handling loaded state
                  break;
                case SendTransactionStatus.error:
                  // Handling error state
                  break;
                case SendTransactionStatus.onEstimateFee:
                  // Showing loading dialog when estimating fee
                  _showLoadingDialog(appTheme);
                case SendTransactionStatus.estimateFeeSuccess:
                  // Navigating to confirmation screen after fee estimation
                  AppNavigator.pop();
                  AppNavigator.push(
                    RoutePath.sendTransactionConfirmation,
                    {
                      'amount': state.amount,
                      'recipient': state.recipientAddress,
                      'sender': state.sender,
                      'transactionFee': state.estimateFee,
                      'gasEstimation': state.gasEstimation,
                    },
                  );
                  break;
                case SendTransactionStatus.estimateFeeError:
                  // Showing toast message on fee estimation error
                  showToast(
                    state.error!,
                  );
                  AppNavigator.pop();
                  break;
              }
            },
            child: Scaffold(
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey: LanguageKey.sendTransactionScreenAppBarTitle,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing05,
                ),
                child: SendTransactionStatusSelector(builder: (status) {
                  switch (status) {
                    case SendTransactionStatus.loading:
                      // Displaying loading widget when in loading state
                      return Center(
                        child: AppLoadingWidget(
                          appTheme: appTheme,
                        ),
                      );
                    case SendTransactionStatus.error:
                    case SendTransactionStatus.onEstimateFee:
                    case SendTransactionStatus.estimateFeeSuccess:
                    case SendTransactionStatus.estimateFeeError:
                    case SendTransactionStatus.loaded:
                      // Building the main column for the screen
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                // Displaying sender information
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey
                                            .sendTransactionScreenSendFrom,
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
                                    // Displaying sender widget
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
                                            .sendTransactionScreenRecipientLabel,
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
                                      // Input field for recipient address
                                      hintText: localization.translate(
                                        LanguageKey
                                            .sendTransactionScreenRecipientHint,
                                      ),
                                      controller: _recipientController,
                                      onClear: _onClearRecipient,
                                      onChanged: _onChangeRecipientData,
                                      onQrTap: () async {
                                        // Handling QR code tap
                                        _showRequestCameraPermission(
                                          appTheme,
                                        );
                                      },
                                      onPaste: _onGetClipBoardData,
                                      constraintManager: ConstraintManager(
                                          isValidOnChanged: true)
                                        ..custom(
                                          errorMessage: localization.translate(
                                            LanguageKey
                                                .sendTransactionScreenRecipientInValid,
                                          ),
                                          customValid: (recipient) {
                                            // Validating recipient address
                                            return WalletAddressValidator
                                                .isValidAddress(recipient);
                                          },
                                        ),
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
                                        LanguageKey.sendTransactionScreenAmount,
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
                                    // Displaying Aura token information
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
                                    // Displaying the account balance
                                    AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return SendTransactionBalanceSelector(
                                          builder: (balance) {
                                            return Text(
                                              '${localization.translate(
                                                LanguageKey
                                                    .sendTransactionScreenBalance,
                                              )}: ${balance.formatAura} ${localization.translate(
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
                                // Input field for transaction amount
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return TextInputNormalSuffixWidget(
                                      hintText: localization.translate(
                                        LanguageKey
                                            .sendTransactionScreenBalanceHint,
                                      ),
                                      onChanged: _onChangeAmount,
                                      controller: _amountController,
                                      // Suffix widget for maximum amount
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
                                                  .sendTransactionScreenAmountMax,
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
                                          errorMessage: localization.translate(
                                            LanguageKey
                                                .sendTransactionScreenAmountInValid,
                                          ),
                                          customValid: _checkValidAmount,
                                        ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Checking if the transaction is ready to submit
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return SendTransactionIsReadySubmitSelector(
                                builder: (isReadySubmit) {
                                  // Displaying the submit button
                                  return PrimaryAppButton(
                                    text: localization.translate(
                                      LanguageKey
                                          .sendTransactionScreenButtonNextTitle,
                                    ),
                                    isDisable: !isReadySubmit,
                                    onPress: () async {
                                      // Triggering event for fee estimation
                                      _bloc.add(
                                        const SendTransactionEventOnEstimateFee(),
                                      );
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

  // Method to get clipboard data
  void _onGetClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    _onChangeRecipientData(
      data?.text ?? '',
      WalletAddressValidator.isValidAddress(
        (data?.text ?? '').trim(),
      ),
    );
  }

  // Method to handle recipient address change
  void _onChangeRecipientData(String value, bool isValid) async {
    _recipientController.text = value;

    if (isValid) {
      // Triggering event for recipient address change
      _bloc.add(
        SendTransactionEventOnChangeRecipientAddress(
          _recipientController.text.trim(),
        ),
      );
    }
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

  // Check if the provided amount is valid
  bool _checkValidAmount(amount) {
    try {
      // Parse the amount as a double
      double am = double.parse(amount);

      // Get the total balance from the bloc's state
      double total = double.parse(_bloc.state.balance);

      // Return true if amount is greater than 0 and less than or equal to the total balance
      return am > 0 && am <= total;
    } catch (e) {
      // Return false if there's an exception (e.g., amount cannot be parsed as a double)
      return false;
    }
  }

  // Show a loading dialog with the provided AppTheme
  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.sendTransactionScreenEstimateFeeLoadingTitle,
      ),
      appTheme: appTheme,
    );
  }

  // Show a dialog requesting camera permission with the provided AppTheme
  void _showRequestCameraPermission(AppTheme appTheme) async {
    // Get the current camera permission status
    PermissionStatus status =
        await SystemPermissionHelper.getCurrentCameraPermissionStatus();

    // Check if camera permission is granted
    if (status.isGranted) {
      // If granted, navigate to the scanner screen
      final result = await AppNavigator.push(
        RoutePath.scanner,
      );

      if(result is String){
        _recipientController.text = result;
      }
    } else {
      // If not granted, show a permission dialog
      if (context.mounted) {
        DialogProvider.showPermissionDialog(
          context,
          appTheme: appTheme,
          onAccept: () {
            // If permission is accepted, close the dialog and request camera permission
            AppNavigator.pop();
            SystemPermissionHelper.requestCameraPermission(
              onSuccessFul: () async {
                // If permission is granted, navigate to the scanner screen
                final result = await AppNavigator.push(
                  RoutePath.scanner,
                );

                if(result is String){
                  _recipientController.text = result;
                }
              },
              reject: () {
                // If permission is rejected, navigate to system settings
                SystemPermissionHelper.goToSettings();
              },
            );
          },
          headerIconPath: AssetIconPath.commonPermissionCamera,
          titleKey: LanguageKey.commonPermissionCameraTitle,
          contentKey: LanguageKey.commonPermissionCameraContent,
        );
      }
    }
  }
}
