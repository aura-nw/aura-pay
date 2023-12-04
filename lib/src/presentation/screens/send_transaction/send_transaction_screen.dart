import 'dart:typed_data';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/presentation/screens/send_transaction/widgets/sender_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_manager.dart';

class SendTransactionScreen extends StatefulWidget {
  const SendTransactionScreen({super.key});

  @override
  State<SendTransactionScreen> createState() => _SendTransactionScreenState();
}

class _SendTransactionScreenState extends State<SendTransactionScreen> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Scaffold(
          appBar: AppBarWithTitle(
            appTheme: appTheme,
            titleKey: LanguageKey.sendTransactionAppBarTitle,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.spacing07,
              vertical: Spacing.spacing08,
            ),
            child: Column(
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
                            style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize06,
                      ),
                      BlocBuilder<AppGlobalCubit, AppGlobalState>(
                        bloc: AppGlobalCubit.of(context),
                        builder: (context, state) {
                          return SenderWidget(
                            appTheme: appTheme,
                            address: 'account.address',
                            accountName: 'account.accountName',
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
                              LanguageKey.sendTransactionRecipientLabel,
                            ),
                            style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          );
                        },
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return TextInputNormalWidget(
                            label: localization.translate(
                              LanguageKey.sendTransactionRecipientHint,
                            ),
                            controller: _recipientController,
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
                            style: AppTypoGraPhy.utilityLabelDefault.copyWith(
                              color: appTheme.contentColorBlack,
                            ),
                          );
                        },
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return TextInputNormalWidget(
                            label: localization.translate(
                              LanguageKey.sendTransactionBalanceHint,
                            ),
                            controller: _amountController,
                            // constraintManager: ConstraintManager(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                AppLocalizationProvider(
                  builder: (localization, _) {
                    return PrimaryAppButton(
                      text: localization.translate(
                        LanguageKey.sendTransactionButtonNextTitle,
                      ),
                      onPress: () async{
                        final smCore = getIt.get<SmartAccountUseCase>();

                        try {
                          final txHash = await smCore.sendToken(
                            userPrivateKey: Uint8List.fromList([1, 167, 9, 13, 97, 133, 153, 162, 131, 227, 36, 21, 22, 241, 201, 234, 221, 113, 23, 252, 110, 40, 178, 214, 69, 89, 53, 4, 237, 194, 244, 3]),
                            smartAccountAddress: 'aura1zfanasp7hdvu6v46t2luznq34ed7fq4zkjhvqcr2wlu6lrd4xalqd92q6g',
                            receiverAddress: 'aura176wt9d8zdg0dgrtvzxvplgdmv99j5yn3enpedl',
                            amount: '2000',
                            fee: '250',
                            gasLimit: 400000,
                          );

                          print('tx hash = $txHash');
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
