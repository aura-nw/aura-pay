import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'signed_in_confirm_recover_phrase_bloc.dart';
import 'signed_in_confirm_recover_phrase_state.dart';
import 'signed_in_confirm_recover_phrase_event.dart';
import 'signed_in_confirm_recover_phrase_selector.dart';
import 'widgets/confirm_recover_phrase_content_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class SignedInConfirmRecoveryPhraseScreen extends StatefulWidget {
  final PyxisWallet pyxisWallet;

  const SignedInConfirmRecoveryPhraseScreen({
    required this.pyxisWallet,
    super.key,
  });

  @override
  State<SignedInConfirmRecoveryPhraseScreen> createState() =>
      _SignedInConfirmRecoveryPhraseScreenState();
}

class _SignedInConfirmRecoveryPhraseScreenState
    extends State<SignedInConfirmRecoveryPhraseScreen> with CustomFlutterToast {
  final TextEditingController _confirmRecoverPhraseController =
      TextEditingController();

  final TextEditingController _walletNameController = TextEditingController();

  final List<String> words = List.empty(growable: true);

  late SignedInConfirmRecoverPhraseBloc _bloc;

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  @override
  void initState() {
    _bloc = getIt.get<SignedInConfirmRecoverPhraseBloc>(
      param1: widget.pyxisWallet,
    );

    words.addAll((widget.pyxisWallet.mnemonic ?? '').split(' '));

    _walletNameController.text = PyxisAccountConstant.defaultNormalWalletName;
    super.initState();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    _confirmRecoverPhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<SignedInConfirmRecoverPhraseBloc,
              SignedInConfirmRecoverPhraseState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInConfirmRecoverPhraseStatus.none:
                  break;
                case SignedInConfirmRecoverPhraseStatus.creating:
                  _showLoading(appTheme);
                  break;
                case SignedInConfirmRecoverPhraseStatus.created:
                  _observer.emit(
                    emitParam: HomeScreenEmitParam(
                      event: HomeScreenObserver.onAddNewAccountSuccessfulEvent,
                    ),
                  );
                  AppNavigator.popUntil(RoutePath.accounts);
                  break;
                case SignedInConfirmRecoverPhraseStatus.error:
                  AppNavigator.pop();
                  showToast(
                    state.error ?? '',
                  );
                  break;
              }
            },
            child: Scaffold(
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey:
                    LanguageKey.signedInConfirmRecoveryPhraseScreenAppBarTitle,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing05,
                    vertical: Spacing.spacing07,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ConfirmRecoverPhraseContentWidget(
                          confirmPhraseController:
                              _confirmRecoverPhraseController,
                          walletNameController: _walletNameController,
                          appTheme: appTheme,
                          words: [
                            words[1],
                            words[8],
                            words[7],
                          ],
                          wordSplit:
                              '${words[3][words[3].length - 1]}${words[4][words[4].length - 1]}${words[5][words[5].length - 1]}',
                          onChangeWalletName: (walletName) {
                            _bloc.add(
                              SignedInConfirmRecoverPhraseOnChangeWalletNameEvent(
                                walletName,
                              ),
                            );
                          },
                          onConfirmChange: (isValid) {
                            _bloc.add(
                              SignedInConfirmRecoverPhraseOnChangeConfirmPhraseEvent(
                                isValid,
                              ),
                            );
                          },
                        ),
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return SignedInConfirmRecoverPhraseIsReadyConfirmSelector(
                              builder: (isReady) {
                            return PrimaryAppButton(
                              text: localization.translate(
                                LanguageKey
                                    .signedInConfirmRecoveryPhraseScreenConfirmButtonTitle,
                              ),
                              onPress: _onConfirm,
                              isDisable: !isReady,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConfirm() {
    _bloc.add(
      const SignedInConfirmRecoverPhraseOnConfirmEvent(),
    );
  }

  void _showLoading(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.signedInConfirmRecoveryPhraseScreenCreating,
      ),
      appTheme: appTheme,
    );
  }
}
