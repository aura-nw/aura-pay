import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'signed_in_create_eoa_by_google_state.dart';
import 'signed_in_create_eoa_by_google_cubit.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class SignedInCreateEOAByGoogleScreen extends StatefulWidget {
  const SignedInCreateEOAByGoogleScreen({super.key});

  @override
  State<SignedInCreateEOAByGoogleScreen> createState() =>
      _SignedInCreateEOAByGoogleScreenState();
}

class _SignedInCreateEOAByGoogleScreenState
    extends State<SignedInCreateEOAByGoogleScreen> with CustomFlutterToast {
  final SignedInCreateEOAByGoogleCubit _cubit =
      getIt.get<SignedInCreateEOAByGoogleCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.showGooglePicker();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _cubit,
          child: BlocListener<SignedInCreateEOAByGoogleCubit,
              SignedInCreateEOAByGoogleState>(
            listener: (context, state) {
              switch (state.status) {
                case SignedInCreateEOAByGoogleStatus.none:
                  break;
                case SignedInCreateEOAByGoogleStatus.logged:
                  AppNavigator.replaceWith(
                    RoutePath.signedInCreateNewWalletByGooglePickName,
                  );
                  break;
                case SignedInCreateEOAByGoogleStatus.error:
                  showToast(state.error ?? '');

                  Future.delayed(
                    const Duration(
                      milliseconds: 600,
                    ),
                  ).then((value) {
                    AppNavigator.pop();
                  });
                  break;
              }
            },
            child: PopScope(
              canPop: false,
              child: Scaffold(
                backgroundColor: appTheme.bodyColorBackground,
                appBar: AppBarWithOnlyTitle(
                  appTheme: appTheme,
                  titleKey:
                      LanguageKey.signedInCreateEoaByGoogleScreenAppBarTitle,
                ),
                body: SafeArea(
                  child: SizedBox(
                    width: context.w,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.spacing05,
                        vertical: Spacing.spacing07,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: BoxSize.boxSize14,
                          ),
                          SvgPicture.asset(
                            AssetIconPath.commonLogoSmall,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize06,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translate(
                                  LanguageKey
                                      .signedInCreateEoaByGoogleScreenCreatingNewWallet,
                                ),
                                style: AppTypoGraPhy.bodyMedium02.copyWith(
                                  color: appTheme.contentColor700,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize03,
                          ),
                          AppLocalizationProvider(
                            builder: (localization, _) {
                              return Text(
                                localization.translate(
                                  LanguageKey
                                      .signedInCreateEoaByGoogleScreenPleaseWait,
                                ),
                                style: AppTypoGraPhy.body01.copyWith(
                                  color: appTheme.contentColor500,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
