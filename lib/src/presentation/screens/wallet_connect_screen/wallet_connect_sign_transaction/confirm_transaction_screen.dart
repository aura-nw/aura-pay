import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/wallet_connect/wallet_connect_state.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/wallet_connect_screen/wallet_connect_sign_transaction/confirm_transaction_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/screens/wallet_connect_screen/wallet_connect_sign_transaction/widgets/confirm_transaction_message_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/scroll_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_box_widget.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'confirm_transaction_screen_bloc.dart';
import 'widgets/confirm_transaction_bottom_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class WalletConnectConfirmTransactionScreen extends StatefulWidget {
  final RequestSessionData sessionData;
  const WalletConnectConfirmTransactionScreen(
      {super.key, required this.sessionData});

  @override
  State<WalletConnectConfirmTransactionScreen> createState() =>
      _WalletConnectConnectConfirmScreenState();
}

class _WalletConnectConnectConfirmScreenState
    extends State<WalletConnectConfirmTransactionScreen> {
  final WalletConnectConfirmTransactionBloc bloc =
      getIt.get<WalletConnectConfirmTransactionBloc>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(builder: (appTheme) {
      return BlocProvider.value(
        value: bloc,
        child: Scaffold(
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey:
                LanguageKey.connectWalletConfirmTransactionScreenAppBarTitle,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing07,
                vertical: Spacing.spacing05,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        WalletConnectConfirmTransactionMessageWidget(
                          appTheme: appTheme,
                          messages: widget.sessionData.params,
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize06,
                        ),
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translate(
                                LanguageKey
                                    .connectWalletConfirmTransactionScreenMemo,
                              ),
                              style: AppTypoGraPhy.utilityLabelDefault.copyWith(
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
                                        .connectWalletConfirmTransactionScreenMemoHint,
                                  ),
                                  onChanged: (memo, _) {},
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  WalletConnectConfirmTranasctionBottomFormWidget(
                      appTheme: appTheme,
                      onEditFee: () {},
                      address: 'address',
                      accountName: 'accountName',
                      onConfirm: () {
                        bloc.add(WalletConnectConfirmTransactionEventOnConfirm(
                            widget.sessionData));
                      }),
                ],
              ),
              
            ),
          ),
        ),
      );
    });
  }
}
