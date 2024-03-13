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
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/text_input_base/text_input_base.dart';

import 'signed_in_create_new_sm_account_pick_account_bloc.dart';
import 'signed_in_create_new_sm_account_pick_account_event.dart';
import 'signed_in_create_new_sm_account_pick_account_selector.dart';
import 'signed_in_create_new_sm_account_pick_account_state.dart';

class SignedInCreateNewSmAccountPickAccountScreen extends StatefulWidget {
  const SignedInCreateNewSmAccountPickAccountScreen({super.key});

  @override
  State<SignedInCreateNewSmAccountPickAccountScreen> createState() =>
      _SignedInCreateNewSmAccountPickAccountScreenState();
}

class _SignedInCreateNewSmAccountPickAccountScreenState
    extends State<SignedInCreateNewSmAccountPickAccountScreen>
    with CustomFlutterToast {
  final SignedInCreateNewSmAccountPickAccountBloc _bloc =
      getIt.get<SignedInCreateNewSmAccountPickAccountBloc>();

  late final TextEditingController _accountNameController;

  @override
  void initState() {
    super.initState();

    /// set default name account
    _accountNameController = TextEditingController()..text = 'Account 1';

    _bloc.add(
      SignedInCreateNewPickAccountChangeEvent(
        accountName: _accountNameController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<SignedInCreateNewSmAccountPickAccountBloc,
              SignedInCreateNewSmAccountPickAccountState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInCreateNewPickAccountStatus.init:
                  break;
                case SignedInCreateNewPickAccountStatus.onLoading:
                  _showLoadingDialog(appTheme);
                  break;
                case SignedInCreateNewPickAccountStatus.onActiveSmartAccount:
                  AppNavigator.pop();
                  _showActiveSmartAccount(appTheme);
                  break;
                case SignedInCreateNewPickAccountStatus
                      .onActiveSmartAccountSuccess:
                  AppNavigator.pop();

                  AppNavigator.replaceAllWith(RoutePath.home);
                  break;
                case SignedInCreateNewPickAccountStatus.onGrantFeeError:
                  AppNavigator.pop();

                  AppNavigator.push(
                    RoutePath.signedInCreateNewAccountScanFee,
                    {
                      'smart_account_address': state.smartAccountAddress,
                      'privateKey': state.userPrivateKey!,
                      'salt': state.saltBytes,
                      'accountName': state.accountName,
                    },
                  );
                  break;
                case SignedInCreateNewPickAccountStatus.onCheckAddressError:
                  AppNavigator.pop();

                  showToast(state.errorMessage!);
                  break;
              }
            },
            child: Scaffold(
              backgroundColor: appTheme.bodyColorBackground,
              appBar: NormalAppBarWidget(
                appTheme: appTheme,
                onViewMoreInformationTap: () {},
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing08,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return RichText(
                                text: TextSpan(
                                  style: AppTypoGraPhy.heading05.copyWith(
                                    color: appTheme.contentColorBlack,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: localization.translate(
                                        LanguageKey
                                            .signedInCreateNewSmartAccountScreenTitleRegionOne,
                                      ),
                                      style: AppTypoGraPhy.heading06.copyWith(
                                        color: appTheme.contentColorBrand,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ${localization.translate(
                                        LanguageKey
                                            .signedInCreateNewSmartAccountScreenTitleRegionTwo,
                                      )}',
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize08,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AssetIconPath.commonLogo,
                              ),
                              const SizedBox(
                                width: BoxSize.boxSize04,
                              ),
                              Expanded(
                                child: AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return TextInputNormalWidget(
                                      label: localization.translate(
                                        LanguageKey
                                            .signedInCreateNewSmartAccountScreenTextFieldTitle,
                                      ),
                                      controller: _accountNameController,
                                      isRequired: true,
                                      onChanged: (value, isValid) {
                                        _bloc.add(
                                          SignedInCreateNewPickAccountChangeEvent(
                                            accountName: value,
                                          ),
                                        );
                                      },
                                      hintText: 'Input account name',
                                      maxLength: 255,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return SignedInCreateNewSmAccountPickAccountIsReadySubmitSelector(
                          builder: (isDisable) {
                            return PrimaryAppButton(
                              text: localization.translate(
                                LanguageKey
                                    .signedInCreateNewSmartAccountScreenButtonTitle,
                              ),
                              isDisable: !isDisable,
                              onPress: () {
                                _bloc.add(
                                  const SignedInCreateNewPickAccountOnSubmitEvent(),
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
        );
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
