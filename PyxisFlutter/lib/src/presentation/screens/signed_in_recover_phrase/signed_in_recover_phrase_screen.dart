import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'signed_in_recover_phrase_cubit.dart';
import 'widgets/pass_phrase_form_widget.dart';
import 'widgets/remind_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class SignedInRecoverPhraseScreen extends StatefulWidget {
  final PyxisWallet pyxisWallet;

  const SignedInRecoverPhraseScreen({
    required this.pyxisWallet,
    super.key,
  });

  @override
  State<SignedInRecoverPhraseScreen> createState() =>
      _SignedInRecoverPhraseScreenState();
}

class _SignedInRecoverPhraseScreenState
    extends State<SignedInRecoverPhraseScreen> with CustomFlutterToast {
  final SignedInRecoverPhraseCubit _cubit =
      getIt.get<SignedInRecoverPhraseCubit>();

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _cubit,
          child: Scaffold(
            backgroundColor: appTheme.bodyColorBackground,
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey: LanguageKey.signedInRecoverPhraseScreenAppBarTitle,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Spacing.spacing07,
                  horizontal: Spacing.spacing05,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          RecoverPhraseRemindWidget(
                            appTheme: appTheme,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize07,
                          ),
                          BlocBuilder<SignedInRecoverPhraseCubit, bool>(
                            builder: (context, state) {
                              if (state) {
                                return RecoveryPhraseWidget(
                                  phrase: widget.pyxisWallet.mnemonic ?? '',
                                  appTheme: appTheme,
                                  onCopy: _onCopy,
                                );
                              }
                              return SvgPicture.asset(
                                AssetImagePath
                                    .commonHidePhrase,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return BlocBuilder<SignedInRecoverPhraseCubit, bool>(
                          builder: (context, state) {
                            return PrimaryAppButton(
                              text: state
                                  ? localization.translate(
                                      LanguageKey
                                          .signedInRecoverPhraseScreenGoNextButtonTitle,
                                    )
                                  : localization.translate(
                                      LanguageKey
                                          .signedInRecoverPhraseScreenShowPhraseButtonTitle,
                                    ),
                              onPress: () {
                                _onClick(state);
                              },
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
        );
      },
    );
  }

  void _onCopy(String phrase) async {
    await Clipboard.setData(
      ClipboardData(text: phrase),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.globalPyxisCopyMessage,
            {
              'value': 'phrase',
            },
          ),
        );
      }
    }
  }

  void _onClick(bool state) {
    if (!state) {
      _cubit.onShowPassPhrase();
    } else {
      AppNavigator.push(
        RoutePath.signedInCreateNewWalletBackupPhraseConfirm,
        widget.pyxisWallet,
      );
    }
  }
}
