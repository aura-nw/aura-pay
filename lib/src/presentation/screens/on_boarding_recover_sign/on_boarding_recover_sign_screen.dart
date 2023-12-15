import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_sign/on_boarding_recover_sign_bloc.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_sign/on_boarding_recover_sign_state.dart';
import 'package:pyxis_mobile/src/presentation/screens/on_boarding_recover_sign/widgets/selected_smart_account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_common/change_fee_form_widget.dart';

import 'on_boarding_recover_sign_event.dart';
import 'on_boarding_recover_sign_selector.dart';

class OnBoardingRecoverSignScreen extends StatefulWidget {
  final AuraAccount account;
  final GoogleAccount googleAccount;

  const OnBoardingRecoverSignScreen({
    super.key,
    required this.googleAccount,
    required this.account,
  });

  @override
  State<OnBoardingRecoverSignScreen> createState() =>
      _OnBoardingRecoverSignScreenState();
}

class _OnBoardingRecoverSignScreenState
    extends State<OnBoardingRecoverSignScreen> with CustomFlutterToast {
  late OnBoardingRecoverSignBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get(
      param1: widget.account,
      param2: widget.googleAccount,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: BlocListener<OnBoardingRecoverSignBloc,
              OnBoardingRecoverSignState>(
            listener: (context, state) {
              switch (state.status) {
                case OnBoardingRecoverSignStatus.none:
                  break;
                case OnBoardingRecoverSignStatus.onRecovering:
                  _showLoadingDialog(appTheme);
                  break;
                case OnBoardingRecoverSignStatus.onRecoverFail:
                  showToast(
                    state.error ?? '',
                  );
                  AppNavigator.pop();
                  break;
                case OnBoardingRecoverSignStatus.onRecoverSuccess:
                  AppNavigator.pop();

                  AppGlobalCubit.of(context).changeState(
                    const AppGlobalState(
                      status: AppGlobalStatus.authorized,
                    ),
                  );
                  break;
              }
            },
            child: Scaffold(
              appBar: NormalAppBarWidget(
                onViewMoreInformationTap: () {},
                appTheme: appTheme,
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: localization.translate(
                                  LanguageKey
                                      .onBoardingRecoverSignScreenTitleRegionOne,
                                ),
                                style: AppTypoGraPhy.heading06.copyWith(
                                  color: appTheme.contentColorBlack,
                                ),
                              ),
                              TextSpan(
                                text: ' ${localization.translate(
                                  LanguageKey
                                      .onBoardingRecoverSignScreenTitleRegionTwo,
                                )}',
                                style: AppTypoGraPhy.heading05.copyWith(
                                  color: appTheme.contentColorBrand,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize05,
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return Text(
                          localization.translate(
                            localization.translate(
                              LanguageKey.onBoardingRecoverSignScreenContent,
                            ),
                          ),
                          style: AppTypoGraPhy.body03.copyWith(
                            color: appTheme.contentColor500,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize05,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetIconPath.commonRoundDivider,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize05,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translate(
                                  localization.translate(
                                    LanguageKey
                                        .onBoardingRecoverSignScreenAccount,
                                  ),
                                ),
                                style:
                                    AppTypoGraPhy.utilityLabelDefault.copyWith(
                                  color: appTheme.contentColorBlack,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize05,
                          ),
                          SelectedSmartAccountWidget(
                            appTheme: appTheme,
                            smartAccountAddress:
                                widget.account.address.addressView,
                            smartAccountName: widget.account.name,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize04,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translate(
                                  LanguageKey
                                      .onBoardingRecoverSignScreenMessages,
                                ),
                                style:
                                    AppTypoGraPhy.utilityLabelDefault.copyWith(
                                  color: appTheme.contentColorBlack,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize04,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AssetIconPath.commonSignMessage,
                              ),
                              const SizedBox(
                                width: BoxSize.boxSize04,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return Text(
                                          localization.translate(
                                            LanguageKey
                                                .onBoardingRecoverSignScreenUpdateKey,
                                          ),
                                          style: AppTypoGraPhy
                                              .utilityLabelDefault
                                              .copyWith(
                                            color: appTheme.contentColorBlack,
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(),
                                    AppLocalizationProvider(
                                      builder: (localization, p1) {
                                        return Text(
                                          localization.translateWithParam(
                                            LanguageKey
                                                .onBoardingRecoverSignScreenUpdateKeyContent,
                                            {
                                              'address': widget
                                                  .account.address.addressView,
                                              'newAddress':
                                                  widget.googleAccount.email,
                                            },
                                          ),
                                          style: AppTypoGraPhy.bodyMedium02
                                              .copyWith(
                                            color: appTheme.contentColor500,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize04,
                          ),
                          const DividerSeparator(),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: Spacing.spacing04,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppLocalizationProvider(
                                  builder: (localization, _) {
                                    return Text(
                                      localization.translate(
                                        LanguageKey
                                            .onBoardingRecoverSignScreenTransactionFee,
                                      ),
                                      style: AppTypoGraPhy.utilityLabelDefault
                                          .copyWith(
                                        color: appTheme.contentColorBlack,
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  children: [
                                    AppLocalizationProvider(
                                      builder: (localization, _) {
                                        return OnBoardingRecoverSignFeeSelector(
                                          builder: (fee) {
                                            return Text(
                                              '${fee.formatAura} ${localization.translate(
                                                LanguageKey.globalPyxisAura,
                                              )}',
                                              style:
                                                  AppTypoGraPhy.body03.copyWith(
                                                color:
                                                    appTheme.contentColorBlack,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      width: BoxSize.boxSize04,
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: _onEditFee,
                                      child: SvgPicture.asset(
                                        AssetIconPath.commonFeeEdit,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize07,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return PrimaryAppButton(
                                text: localization.translate(
                                  LanguageKey
                                      .onBoardingRecoverSignScreenConfirmButtonTitle,
                                ),
                                onPress: () {
                                  _bloc.add(
                                    const OnBoardingRecoverSignEventOnConfirm(),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onEditFee() async {
    final fee = await AppBottomSheetLayout.showFullScreenDialog(
      context,
      child: ChangeFeeFormWidget(
        max: double.parse(
          _bloc.state.highTransactionFee,
        ),
        min: double.parse(
          _bloc.state.lowTransactionFee,
        ),
        currentValue: double.parse(
          _bloc.state.transactionFee,
        ),
      ),
    );

    if (fee is double) {
      _bloc.add(
        OnBoardingRecoverSignEventOnChangeFee(
          fee: fee.round().toString(),
        ),
      );
    }
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.onBoardingRecoverSignScreenRecovering,
      ),
      appTheme: appTheme,
    );
  }
}
