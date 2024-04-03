import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'on_boarding_confirm_recover_phrase_bloc.dart';
import 'on_boarding_confirm_recover_phrase_state.dart';
import 'on_boarding_confirm_recover_phrase_event.dart';
import 'on_boarding_confirm_recover_phrase_selector.dart';
import 'widgets/confirm_recover_phrase_content_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class OnBoardingConfirmRecoveryPhraseScreen extends StatefulWidget {
  final PyxisWallet pyxisWallet;

  const OnBoardingConfirmRecoveryPhraseScreen({
    required this.pyxisWallet,
    super.key,
  });

  @override
  State<OnBoardingConfirmRecoveryPhraseScreen> createState() =>
      _OnBoardingConfirmRecoveryPhraseScreenState();
}

class _OnBoardingConfirmRecoveryPhraseScreenState
    extends State<OnBoardingConfirmRecoveryPhraseScreen>
    with CustomFlutterToast {
  final TextEditingController _confirmRecoverPhraseController =
      TextEditingController();

  final TextEditingController _walletNameController = TextEditingController();

  final List<String> words = List.empty(growable: true);

  late OnBoardingConfirmRecoverPhraseBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get<OnBoardingConfirmRecoverPhraseBloc>(
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
          child: BlocListener<OnBoardingConfirmRecoverPhraseBloc,
              OnBoardingConfirmRecoverPhraseState>(
            listener: (context, state) {
              switch (state.status) {
                case OnBoardingConfirmRecoverPhraseStatus.none:
                  break;
                case OnBoardingConfirmRecoverPhraseStatus.creating:
                  _showLoading(appTheme);
                  break;
                case OnBoardingConfirmRecoverPhraseStatus.created:
                  AppNavigator.pop();
                  AppGlobalCubit.of(context).changeState(
                    const AppGlobalState(
                      status: AppGlobalStatus.authorized,
                      onBoardingStatus:
                          OnBoardingStatus.createNormalAccountSuccessFul,
                    ),
                  );
                  break;
                case OnBoardingConfirmRecoverPhraseStatus.error:
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
                titleKey: LanguageKey
                    .onBoardingConfirmRecoveryPhraseScreenAppBarTitle,
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
                            words[5],
                            words[7],
                          ],
                          wordSplit:
                              '${words[3][words[3].length - 1]}${words[4][words[4].length - 1]}${words[5][words[5].length - 1]}',
                          onChangeWalletName: (walletName) {
                            _bloc.add(
                              OnBoardingConfirmRecoverPhraseOnChangeWalletNameEvent(
                                walletName,
                              ),
                            );
                          },
                          onConfirmChange: (isValid) {
                            _bloc.add(
                              OnBoardingConfirmRecoverPhraseOnChangeConfirmPhraseEvent(
                                isValid,
                              ),
                            );
                          },
                        ),
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return OnBoardingConfirmRecoverPhraseIsReadyConfirmSelector(
                              builder: (isReady) {
                            return PrimaryAppButton(
                              text: localization.translate(
                                LanguageKey
                                    .onBoardingConfirmRecoveryPhraseScreenConfirmButtonTitle,
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
      const OnBoardingConfirmRecoverPhraseOnConfirmEvent(),
    );
  }

  void _showLoading(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.onBoardingConfirmRecoveryPhraseScreenCreating,
      ),
      appTheme: appTheme,
    );
  }
}
