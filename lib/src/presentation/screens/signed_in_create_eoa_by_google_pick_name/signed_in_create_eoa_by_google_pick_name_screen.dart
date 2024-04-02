import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/pyxis_account_constant.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

import 'signed_in_create_eoa_by_google_pick_name_bloc.dart';
import 'signed_in_create_eoa_by_google_pick_name_event.dart';
import 'signed_in_create_eoa_by_google_pick_name_selector.dart';
import 'signed_in_create_eoa_by_google_pick_name_state.dart';

class SignedInCreateEOAByGooglePickNameScreen extends StatefulWidget {
  const SignedInCreateEOAByGooglePickNameScreen({
    super.key,
  });

  @override
  State<SignedInCreateEOAByGooglePickNameScreen> createState() =>
      _SignedInCreateEOAByGooglePickNameScreenState();
}

class _SignedInCreateEOAByGooglePickNameScreenState
    extends State<SignedInCreateEOAByGooglePickNameScreen>
    with CustomFlutterToast {
  final SignedInCreateEOAByGooglePickNameBloc _bloc =
      getIt.get<SignedInCreateEOAByGooglePickNameBloc>();

  final TextEditingController _walletNameController = TextEditingController();

  final int _defaultWalletNameLength = 32;

  @override
  void initState() {
    _walletNameController.text = PyxisAccountConstant.defaultNormalWalletName;
    super.initState();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<SignedInCreateEOAByGooglePickNameBloc,
              SignedInCreateEOAByGooglePickNameState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInCreateEOAByGooglePickNameStatus.none:
                  break;
                case SignedInCreateEOAByGooglePickNameStatus.creating:
                  _showLoadingDialog(appTheme);
                  break;
                case SignedInCreateEOAByGooglePickNameStatus.created:
                  AppNavigator.pop();
                  
                  break;
                case SignedInCreateEOAByGooglePickNameStatus.error:
                  AppNavigator.pop();
                  showToast(state.error ?? '');
                  break;
              }
            },
            child: Scaffold(
              backgroundColor: appTheme.bodyColorBackground,
              appBar: AppBarWithTitle(
                appTheme: appTheme,
                titleKey: LanguageKey
                    .signedInCreateEoaByGooglePickNameScreenAppBarTitle,
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
                        child: ListView(
                          children: [
                            SvgPicture.asset(
                              AssetIconPath.commonSmartAccountAvatarDefault,
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize08,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey
                                            .signedInCreateEoaByGooglePickNameScreenNameYourWallet,
                                      ),
                                      style:
                                          AppTypoGraPhy.utilityLabelSm.copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    );
                                  },
                                ),
                                SignedInCreateEOAByGooglePickNameWalletNameSelector(
                                    builder: (walletName) {
                                  return Text(
                                    '${walletName.trim().length}/$_defaultWalletNameLength',
                                    style: AppTypoGraPhy.bodyMedium01.copyWith(
                                      color: appTheme.contentColor500,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return TextInputNormalWidget(
                                  controller: _walletNameController,
                                  hintText: localization.translate(
                                    LanguageKey
                                        .signedInCreateEoaByGooglePickNameScreenNameYourWalletHint,
                                  ),
                                  onChanged: (walletName, _) {
                                    _bloc.add(
                                      SignedInCreateEOAByGooglePickNameOnChangeWalletNameEvent(
                                        walletName,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return SignedInCreateEOAByGooglePickNameIsReadyConfirmSelector(
                            builder: (isReadyConfirm) {
                              return PrimaryAppButton(
                                text: localization.translate(
                                  LanguageKey
                                      .signedInCreateEoaByGooglePickNameScreenCreateButtonTitle,
                                ),
                                isDisable: !isReadyConfirm,
                                onPress: () {
                                  _bloc.add(
                                    const SignedInCreateEOAByGooglePickNameOnConfirmEvent(),
                                  );
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
          ),
        );
      },
    );
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.signedInCreateEoaByGooglePickNameScreenCreating,
      ),
      appTheme: appTheme,
    );
  }
}
