import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/utils/app_util.dart';
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
    with StateFulBaseScreen {
  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TransactionInformationWidget(
                  accountName: widget.account.name,
                  amount: widget.amount,
                  from: widget.appNetwork.getAddress(
                    widget.account,
                  ),
                  recipient: widget.recipient,
                  appTheme: appTheme,
                  onEditFee: () {},
                  localization: localization,
                ),
              ],
            ),
          ),
        ),
        PrimaryAppButton(
          text: localization.translate(
            LanguageKey.confirmSendScreenConfirmSend,
          ),
        ),
      ],
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Scaffold(
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
    );
  }
}
