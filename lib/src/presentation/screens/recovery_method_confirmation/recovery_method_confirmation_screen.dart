import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/dart_core_extension.dart';
import 'recovery_method_confirmation_screen_bloc.dart';
import 'recovery_method_confirmation_screen_event.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class RecoveryMethodConfirmationScreen extends StatefulWidget {
  final GoogleAccount googleAccount;
  final AuraAccount account;

  const RecoveryMethodConfirmationScreen({
    required this.account,
    required this.googleAccount,
    super.key,
  });

  @override
  State<RecoveryMethodConfirmationScreen> createState() =>
      _RecoveryMethodConfirmationScreenState();
}

class _RecoveryMethodConfirmationScreenState
    extends State<RecoveryMethodConfirmationScreen> {
  late RecoveryMethodConfirmationBloc _bloc;

  @override
  void initState() {
    _bloc = getIt.get<RecoveryMethodConfirmationBloc>(
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
          child: Scaffold(
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey: LanguageKey.recoveryMethodConfirmationScreenAppBarTitle,
            ),
            body: Padding(
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
                        const SizedBox(
                          height: BoxSize.boxSize04,
                        ),
                        SvgPicture.asset(
                          AssetIconPath.recoveryConfirmation,
                        ),
                        const SizedBox(
                          height: BoxSize.boxSize06,
                        ),
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: localization.translate(
                                      LanguageKey
                                          .recoveryMethodConfirmationScreenContentRegionOne,
                                    ),
                                    style: AppTypoGraPhy.body03.copyWith(
                                      color: appTheme.contentColor700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${widget.googleAccount.email} ',
                                    style: AppTypoGraPhy.bodyMedium03.copyWith(
                                      color: appTheme.contentColorBlack,
                                    ),
                                  ),
                                  TextSpan(
                                    text: localization.translate(
                                      LanguageKey
                                          .recoveryMethodConfirmationScreenContentRegionTwo,
                                    ),
                                    style: AppTypoGraPhy.body03.copyWith(
                                      color: appTheme.contentColor700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${widget.account.address}',
                                    style: AppTypoGraPhy.bodyMedium03.copyWith(
                                      color: appTheme.contentColorBlack,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        AssetIconPath.recoveryConfirmationDivider,
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize04,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return Text(
                            localization.translate(
                              LanguageKey
                                  .recoveryMethodConfirmationScreenMessages,
                            ),
                            style: AppTypoGraPhy.utilityLabelDefault.copyWith(
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
                            AssetIconPath.recoveryConfirmationMessage,
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
                                            .recoveryMethodConfirmationScreenChangeRecovery,
                                      ),
                                      style: AppTypoGraPhy.utilityLabelDefault
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
                                            .recoveryMethodConfirmationScreenMessage,
                                        {
                                          'account': widget.googleAccount.email,
                                          'address': widget
                                              .account.address.addressView,
                                        },
                                      ),
                                      style:
                                          AppTypoGraPhy.bodyMedium02.copyWith(
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
                        height: BoxSize.boxSize07,
                      ),
                      AppLocalizationProvider(
                        builder: (localization, _) {
                          return PrimaryAppButton(
                            text: localization.translate(
                              LanguageKey.sendTransactionConfirmationScreenSend,
                            ),
                            onPress: () {
                              _bloc.add(
                                const RecoveryMethodConfirmationEventOnConfirm(),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: BoxSize.boxSize08,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
