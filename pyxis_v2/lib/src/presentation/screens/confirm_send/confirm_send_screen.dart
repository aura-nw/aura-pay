import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/app_configs/pyxis_mobile_config.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/observer/home_page_observer.dart';
import 'package:pyxis_v2/src/core/utils/app_util.dart';
import 'package:pyxis_v2/src/core/utils/aura_util.dart';
import 'package:pyxis_v2/src/core/utils/toast.dart';
import 'package:pyxis_v2/src/navigator.dart';
import 'confirm_send_selector.dart';
import 'confirm_send_state.dart';
import 'widgets/message_form.dart';
import 'package:pyxis_v2/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_provider.dart';
import 'package:pyxis_v2/src/presentation/widgets/change_fee_form_widget.dart';
import 'confirm_send_bloc.dart';
import 'confirm_send_event.dart';
import 'widgets/app_bar.dart';
import 'widgets/transaction_information.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';

final class ConfirmSendScreen extends StatefulWidget {
  final AppNetwork appNetwork;
  final Account account;
  final String amount;
  final String recipient;
  final Balance balance;

  const ConfirmSendScreen({
    required this.appNetwork,
    required this.account,
    required this.amount,
    required this.recipient,
    required this.balance,
    super.key,
  });

  @override
  State<ConfirmSendScreen> createState() => _ConfirmSendScreenState();
}

class _ConfirmSendScreenState extends State<ConfirmSendScreen>
    with StateFulBaseScreen, CustomFlutterToast {
  final PyxisMobileConfig _config = getIt.get<PyxisMobileConfig>();
  final HomePageObserver _homePageObserver = getIt.get<HomePageObserver>();
  late ConfirmSendBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get<ConfirmSendBloc>(
      param1: _config,
      param2: {
        'network': widget.appNetwork,
        'account': widget.account,
        'amount': widget.amount,
        'recipient': widget.recipient,
        'balance': widget.balance,
      },
    );

    _bloc.add(
      const ConfirmSendOnInitEvent(),
    );
    super.initState();
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ConfirmSendScreenMessageFormWidget(
                    appTheme: appTheme,
                    localization: localization,
                    onChangeIsShowedMsg: _onChangeIsShowedMsg,
                    amount: widget.amount,
                    tokenName: widget.balance.name ?? '',
                    recipient: widget.recipient,
                    networkType: widget.appNetwork.type,
                  ),
                ),
              ),
              TransactionInformationWidget(
                accountName: widget.account.name,
                amount: widget.amount,
                from: widget.appNetwork.getAddress(
                  widget.account,
                ),
                recipient: widget.recipient,
                appTheme: appTheme,
                onEditFee: (gasPrice, gasEstimation) {
                  _onEditFee(
                    appTheme,
                    localization,
                    gasPrice.toDouble() * 1.25,
                    gasPrice.toDouble() * 0.75,
                    gasPrice.toDouble(),
                    gasEstimation.toDouble(),
                  );
                },
                localization: localization,
                balance: widget.balance,
              ),
            ],
          ),
        ),
        ConfirmSendStatusSelector(builder: (status) {
          return PrimaryAppButton(
            text: localization.translate(
              LanguageKey.confirmSendScreenConfirmSend,
            ),
            onPress: _onSubmit,
            loading: status == ConfirmSendStatus.sending,
          );
        }),
      ],
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return PopScope(
      canPop: false,
      child: BlocProvider.value(
        value: _bloc,
        child: BlocListener<ConfirmSendBloc, ConfirmSendState>(
          listener: (context, state) {
            switch (state.status) {
              case ConfirmSendStatus.init:
                break;
              case ConfirmSendStatus.sending:
                showLoading();
                break;
              case ConfirmSendStatus.sent:
                _homePageObserver.emit(
                  emitParam: HomePageEmitParam(
                    event: HomePageObserver.onSendTokenDone,
                    data: state.balance.type,
                  ),
                );
                hideLoading();
                AppNavigator.push(
                  RoutePath.transactionResult,
                  {
                    'from': widget.appNetwork.getAddress(
                      widget.account,
                    ),
                    'to': widget.recipient,
                    'amount': widget.amount,
                    'time': state.timeStamp,
                    'hash': state.hash,
                  },
                );
                break;
              case ConfirmSendStatus.error:
                hideLoading();
                showToast(state.error ?? '');
                break;
            }
          },
          child: Scaffold(
            backgroundColor: appTheme.bgPrimary,
            appBar: AppBarDefault(
              appTheme: appTheme,
              localization: localization,
              title: ConfirmSendScreenAppBar(
                appTheme: appTheme,
                localization: localization,
                appNetwork: widget.appNetwork,
              ),
            ),
            body: child,
          ),
        ),
      ),
    );
  }

  void _onChangeIsShowedMsg() {
    _bloc.add(
      const ConfirmSendOnChangeIsShowedMessageEvent(),
    );
  }

  void _onEditFee(
    AppTheme appTheme,
    AppLocalizationManager localization,
    double max,
    double min,
    double currentValue,
    double estimationGas,
  ) async {
    final gasPrice = await AppBottomSheetProvider.showFullScreenDialog<double?>(
      context,
      child: ChangeFeeFormWidget(
        max: max,
        min: min,
        currentValue: currentValue,
        appTheme: appTheme,
        localization: localization,
        convertFee: (value) {
          return widget.balance.type.formatBalance(
            (value * estimationGas).toString(),
            customDecimal: widget.balance.decimal,
          );
        },
      ),
      appTheme: appTheme,
    );

    if (gasPrice != null) {
      _bloc.add(
        ConfirmSendOnChangeFeeEvent(
          gasPrice: gasPrice,
        ),
      );
    }
  }

  void _onSubmit() async {
    _bloc.add(
      const ConfirmSendOnSubmitEvent(),
    );
  }
}
