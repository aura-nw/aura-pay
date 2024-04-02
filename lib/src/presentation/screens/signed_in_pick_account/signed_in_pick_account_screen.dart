import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'signed_in_pick_account_bloc.dart';
import 'signed_in_pick_account_event.dart';
import 'signed_in_pick_account_selector.dart';
import 'signed_in_pick_account_state.dart';

class SignedInPickAccountScreen extends StatefulWidget {
  const SignedInPickAccountScreen({super.key});

  @override
  State<SignedInPickAccountScreen> createState() =>
      _SignedInPickAccountScreenState();
}

class _SignedInPickAccountScreenState extends State<SignedInPickAccountScreen>
    with CustomFlutterToast {
  final SignedInPickAccountBloc _bloc = getIt.get<SignedInPickAccountBloc>();

  late final TextEditingController _accountNameController;
  final int _defaultWalletNameLength = 32;

  @override
  void initState() {
    super.initState();

    /// set default name account
    _accountNameController = TextEditingController()
      ..text = PyxisAccountConstant.defaultName;

    _bloc.add(
      SignedInPickAccountOnPickAccountChangeEvent(
        accountName: _accountNameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(builder: (localization, _) {
          return BlocProvider.value(
            value: _bloc,
            child:
                BlocListener<SignedInPickAccountBloc, SignedInPickAccountState>(
              listener: (context, state) {
                switch (state.status) {
                  case SignedInPickAccountStatus.init:
                    break;
                  case SignedInPickAccountStatus.onLoading:
                    _showLoadingDialog(appTheme);
                    break;
                  case SignedInPickAccountStatus.onActiveSmartAccount:
                    AppNavigator.pop();
                    _showActiveSmartAccount(appTheme);
                    break;
                  case SignedInPickAccountStatus.onActiveSmartAccountSuccess:
                    AppNavigator.pop();
                    break;
                  case SignedInPickAccountStatus.onGrantFeeError:
                    AppNavigator.pop();

                    AppNavigator.push(
                      RoutePath.scanQrFee,
                      {
                        'smart_account_address': state.smartAccountAddress,
                        'privateKey': state.userPrivateKey!,
                        'salt': state.saltBytes,
                        'accountName': state.accountName,
                      },
                    );
                    break;
                  case SignedInPickAccountStatus.onCheckAddressError:
                    AppNavigator.pop();

                    showToast(state.errorMessage!);
                    break;
                }
              },
              child: Scaffold(
                backgroundColor: appTheme.bodyColorBackground,
                appBar: NormalAppBarWithTitleWidget(
                  appTheme: appTheme,
                  onViewMoreInformationTap: () {},
                  title: localization.translate(
                    LanguageKey.signedInCreateNewSmartAccountScreenAppBarTitle,
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing07,
                      vertical: Spacing.spacing05,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              SvgPicture.asset(
                                AssetIconPath.commonSmartAccountAvatarDefault,
                              ),
                              const SizedBox(
                                height: BoxSize.boxSize08,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppLocalizationProvider(
                                    builder: (localization, _) {
                                      return Text(
                                        localization.translate(
                                          LanguageKey
                                              .signedInCreateNewSmartAccountScreenNameYourAccount,
                                        ),
                                        style: AppTypoGraPhy.utilityLabelSm
                                            .copyWith(
                                          color: appTheme.contentColorBlack,
                                        ),
                                      );
                                    },
                                  ),
                                  SignedInPickAccountAccountNameSelector(
                                    builder: (accountName) {
                                      return Text(
                                        '${accountName.trim().length}/$_defaultWalletNameLength',
                                        style:
                                            AppTypoGraPhy.bodyMedium01.copyWith(
                                          color: appTheme.contentColor500,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              TextInputNormalWidget(
                                controller: _accountNameController,
                                onChanged: (value, isValid) {
                                  _bloc.add(
                                    SignedInPickAccountOnPickAccountChangeEvent(
                                      accountName: value,
                                    ),
                                  );
                                },
                                hintText: localization.translate(
                                  LanguageKey
                                      .signedInCreateNewSmartAccountScreenNameYourAccountHint,
                                ),
                                maxLength: _defaultWalletNameLength,
                              ),
                            ],
                          ),
                        ),
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return SignedInPickAccountIsReadySubmitSelector(
                              builder: (isDisable) {
                                return PrimaryAppButton(
                                  text: localization.translate(
                                    LanguageKey
                                        .signedInCreateNewSmartAccountScreenButtonTitle,
                                  ),
                                  isDisable: !isDisable,
                                  onPress: () {
                                    _bloc.add(
                                      const SignedInPickAccountOnSubmitEvent(),
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
        });
      },
    );
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.signedInCreateNewSmartAccountScreenDialogLoadingTitle,
      ),
      appTheme: appTheme,
    );
  }

  void _showActiveSmartAccount(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.signedInCreateNewSmartAccountScreenDialogLoadingCreateTitle,
      ),
      appTheme: appTheme,
    );
  }
}
