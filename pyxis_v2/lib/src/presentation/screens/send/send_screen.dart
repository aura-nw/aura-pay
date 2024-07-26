import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/network.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/navigator.dart';
import 'package:pyxis_v2/src/presentation/screens/send/send_selector.dart';
import 'package:pyxis_v2/src/presentation/screens/send/send_state.dart';
import 'package:pyxis_v2/src/presentation/screens/send/widgets/app_bar.dart';
import 'package:pyxis_v2/src/presentation/screens/send/widgets/select_token.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_loading_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_provider.dart';
import 'package:pyxis_v2/src/presentation/widgets/select_network_widget.dart';
import 'send_event.dart';
import 'widgets/amount_widget.dart';
import 'widgets/from_widget.dart';
import 'widgets/to_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

import 'send_bloc.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> with StateFulBaseScreen {
  final PyxisMobileConfig _config = getIt.get<PyxisMobileConfig>();
  late SendBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get<SendBloc>(
      param1: createNetwork(_config),
    );
    _bloc.add(
      const SendOnInitEvent(),
    );
    super.initState();
  }

  @override
  EdgeInsets? padding() {
    return EdgeInsets.zero;
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Column(
      children: [
        Expanded(
          child: SendStatusSelector(
            builder: (status) {
              switch (status) {
                case SendStatus.loading:
                  return Center(
                    child: AppLoadingWidget(
                      appTheme: appTheme,
                    ),
                  );
                case SendStatus.loaded:
                case SendStatus.error:
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SendScreenFromWidget(
                          appTheme: appTheme,
                          localization: localization,
                          padding: defaultPadding(),
                        ),
                        Padding(
                          padding: defaultPadding(),
                          child: Column(
                            children: [
                              SendScreenToWidget(
                                appTheme: appTheme,
                                localization: localization,
                                onContactTap: () {},
                                onScanTap: () {},
                                onChangeSaved: _onChangeSaved,
                                onAddressChanged: _onAddressChanged,
                              ),
                              const SizedBox(
                                height: BoxSize.boxSize07,
                              ),
                              SendScreenAmountToSendWidget(
                                appTheme: appTheme,
                                localization: localization,
                                onChanged: _onChangeAmount,
                                onSelectToken: (token, tokenMarkets, tokens) {
                                  _onSelectTokens(
                                    token,
                                    tokenMarkets,
                                    tokens,
                                    appTheme,
                                    localization,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
        ),
        Padding(
          padding: defaultPadding(),
          child: SendAlreadySelector(
            builder: (already) {
              return PrimaryAppButton(
                text: localization.translate(
                  LanguageKey.sendScreenNext,
                ),
                isDisable: !already,
                onPress: () {
                  final state = _bloc.state;
                  AppNavigator.push(RoutePath.confirmSend, {
                    'appNetwork': state.selectedNetwork,
                    'account': state.account,
                    'amount': state.amountToSend,
                    'recipient': state.toAddress,
                    'balance': state.selectedToken,
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: appTheme.bgPrimary,
        appBar: AppBarDefault(
          appTheme: appTheme,
          localization: localization,
          title: SendAppBar(
            appTheme: appTheme,
            localization: localization,
            onSelectNetwork: (networks, account) => _onChangeNetwork(
              appTheme,
              localization,
              networks,
              account,
            ),
          ),
        ),
        body: child,
      ),
    );
  }

  void _onChangeSaved(bool isSave) {
    _bloc.add(
      const SendOnChangeSavedEvent(),
    );
  }

  void _onChangeNetwork(
    AppTheme appTheme,
    AppLocalizationManager localization,
    List<AppNetwork> networks,
    Account? account,
  ) async {
    if (account == null) return;

    final network = await AppBottomSheetProvider.showFullScreenDialog<AppNetwork?>(
      context,
      child: SelectNetworkAccountWidget(
        appTheme: appTheme,
        localization: localization,
        networks: networks,
        account: account,
      ),
      appTheme: appTheme,
    );

    if(network != null){
      _bloc.add(
        SendOnChangeNetworkEvent(
          network,
        ),
      );
    }
  }

  void _onAddressChanged(String address, bool isValid) {
    _bloc.add(
      SendOnChangeToEvent(
        address: address,
      ),
    );
  }

  void _onChangeAmount(String amount, bool isValid) {
    _bloc.add(
      SendOnChangeAmountEvent(
        amount: amount,
      ),
    );
  }

  void _onSelectTokens(
    Balance token,
    List<TokenMarket> tokenMarkets,
    List<Balance> tokens,
    AppTheme appTheme,
    AppLocalizationManager localization,
  ) async {
    final selectedToken =
        await AppBottomSheetProvider.showFullScreenDialog<Balance?>(
      context,
      child: SendSelectTokensWidget(
        appTheme: appTheme,
        localization: localization,
        tokens: tokens,
        tokenMarkets: tokenMarkets,
        currentToken: token,
      ),
      appTheme: appTheme,
    );

    if (selectedToken != null) {
      _bloc.add(
        SendOnChangeTokenEvent(
          selectedToken,
        ),
      );
      print(selectedToken.type);
    }
  }
}
