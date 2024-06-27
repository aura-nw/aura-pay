import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/aura_scan.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/helpers/app_launcher.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'widgets/transaction_information_form_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class SendTransactionResultScreen extends StatefulWidget {
  final String sender;
  final String recipient;
  final String timeCreated;
  final String txHash;
  final String amount;

  const SendTransactionResultScreen({
    required this.txHash,
    required this.recipient,
    required this.sender,
    required this.timeCreated,
    required this.amount,
    super.key,
  });

  @override
  State<SendTransactionResultScreen> createState() =>
      _SendTransactionResultScreenState();
}

class _SendTransactionResultScreenState
    extends State<SendTransactionResultScreen> with CustomFlutterToast {
  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              top: context.statusBar,
              right: Spacing.spacing07,
              left: Spacing.spacing07,
              bottom: Spacing.spacing05,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: BoxSize.boxSize08,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      SvgPicture.asset(
                        AssetIconPath.sendSuccessfulLogo,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize08,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey.sendTransactionResultScreenSuccessFul,
                            ),
                            textAlign: TextAlign.center,
                            style: AppTypoGraPhy.heading03.copyWith(
                              color: appTheme.contentColor700,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize03,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            '${widget.amount} ${localization.translate(
                              LanguageKey.globalPyxisAura,
                            )}',
                            textAlign: TextAlign.center,
                            style: AppTypoGraPhy.heading04.copyWith(
                              color: appTheme.contentColorBrand,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize07,
                      ),
                      TransactionInformationFormWidget(
                        appTheme: appTheme,
                        sender: widget.sender,
                        recipient: widget.recipient,
                        time: widget.timeCreated,
                        txHash: widget.txHash,
                        onCopy: () {
                          _onCopy(
                            context,
                          );
                        },
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppLauncher.launch(
                      AuraScan.transaction(
                        widget.txHash,
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AppLocalizationProvider(
                    builder: (localization, _) {
                      return TextAppButton(
                        text: localization.translate(
                          LanguageKey
                              .sendTransactionResultScreenViewTransaction,
                        ),
                        suffix: SvgPicture.asset(
                          AssetIconPath.sendSuccessfulView,
                        ),
                      );
                    },
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey
                            .sendTransactionResultScreenButtonBackToHomePage,
                      ),
                      onPress: () {
                        AppNavigator.popUntil(
                          RoutePath.home,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: BoxSize.boxSize08,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onCopy(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
        text: widget.txHash,
      ),
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
