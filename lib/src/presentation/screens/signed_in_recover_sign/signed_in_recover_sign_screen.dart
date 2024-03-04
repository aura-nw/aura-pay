import 'package:domain/domain.dart';
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
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/aura_util.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'signed_in_recover_sign_bloc.dart';
import 'signed_in_recover_sign_event.dart';
import 'signed_in_recover_sign_selector.dart';
import 'signed_in_recover_sign_state.dart';
import 'widgets/selected_smart_account_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';
import 'package:pyxis_mobile/src/presentation/widgets/bottom_sheet_base/app_bottom_sheet_layout.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/divider_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/transaction_common/change_fee_form_widget.dart';

class SignedInRecoverSignScreen extends StatefulWidget {
  final PyxisRecoveryAccount account;
  final GoogleAccount googleAccount;

  const SignedInRecoverSignScreen({
    super.key,
    required this.googleAccount,
    required this.account,
  });

  @override
  State<SignedInRecoverSignScreen> createState() =>
      _SignedInRecoverSignScreenState();
}

class _SignedInRecoverSignScreenState extends State<SignedInRecoverSignScreen>
    with CustomFlutterToast {
  late SignedInRecoverSignBloc _bloc;

  final HomeScreenObserver _observer = getIt.get<HomeScreenObserver>();

  @override
  void initState() {
    _bloc = getIt.get<SignedInRecoverSignBloc>(
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
          child: BlocListener<SignedInRecoverSignBloc, SignedInRecoverSignState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInRecoverSignStatus.none:
                  break;
                case SignedInRecoverSignStatus.onRecovering:
                  _showLoadingDialog(appTheme);
                  break;
                case SignedInRecoverSignStatus.onRecoverFail:
                  showToast(
                    state.error ?? '',
                  );
                  AppNavigator.pop();
                  break;
                case SignedInRecoverSignStatus.onRecoverSuccess:
                  _observer.emit(
                    emitParam: HomeScreenEmitParam(
                      event: HomeScreenObserver.recoverAccountSuccessfulEvent,
                    ),
                  );
                  AppNavigator.popUntil(
                    RoutePath.home,
                  );
                  break;
              }
            },
            child: Scaffold(
              appBar: NormalAppBarWidget(
                onViewMoreInformationTap: () {},
                appTheme: appTheme,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing07,
                    vertical: Spacing.spacing05,
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
                                        .signedInRecoverSignScreenTitleRegionOne,
                                  ),
                                  style: AppTypoGraPhy.heading06.copyWith(
                                    color: appTheme.contentColorBlack,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${localization.translate(
                                    LanguageKey
                                        .signedInRecoverSignScreenTitleRegionTwo,
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
                                LanguageKey.signedInRecoverSignScreenContent,
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
                              AssetIconPath.commonTransactionDivider,
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
                                          .signedInRecoverSignScreenAccount,
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
                                  widget.account.smartAccountAddress.addressView,
                              smartAccountName: widget.account.name ??
                                  PyxisAccountConstant.unName,
                            ),
                            const SizedBox(
                              height: BoxSize.boxSize04,
                            ),
                            AppLocalizationProvider(
                              builder: (localization, _) {
                                return Text(
                                  localization.translate(
                                    LanguageKey.signedInRecoverSignScreenMessages,
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
                                                  .signedInRecoverSignScreenUpdateKey,
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
                                                  .signedInRecoverSignScreenUpdateKeyContent,
                                              {
                                                'address': widget
                                                    .account
                                                    .smartAccountAddress
                                                    .addressView,
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
                                              .signedInRecoverSignScreenTransactionFee,
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
                                          return SignedInRecoverSignFeeSelector(
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
                                        .signedInRecoverSignScreenConfirmButtonTitle,
                                  ),
                                  onPress: () {
                                    _bloc.add(
                                      const SignedInRecoverSignEventOnConfirm(),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
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
        SignedInRecoverSignEventOnChangeFee(
          fee: fee.round().toString(),
        ),
      );
    }
  }

  void _showLoadingDialog(AppTheme appTheme) {
    DialogProvider.showLoadingDialog(
      context,
      content: AppLocalizationManager.of(context).translate(
        LanguageKey.signedInRecoverSignScreenRecovering,
      ),
      appTheme: appTheme,
    );
  }
}
