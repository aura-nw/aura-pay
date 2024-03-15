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
import 'on_boarding_create_eoa_state.dart';
import 'on_boarding_create_eoa_cubit.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class OnBoardingCreateEOAScreen extends StatefulWidget {
  const OnBoardingCreateEOAScreen({super.key});

  @override
  State<OnBoardingCreateEOAScreen> createState() =>
      _OnBoardingCreateEOAScreenState();
}

class _OnBoardingCreateEOAScreenState extends State<OnBoardingCreateEOAScreen>
    with CustomFlutterToast {
  final OnBoardingCreateEOACubit _cubit = getIt.get<OnBoardingCreateEOACubit>();

  @override
  void initState() {
    super.initState();

    _cubit.startCreate();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return AppLocalizationProvider(
          builder: (localization, _) {
            return BlocProvider.value(
              value: _cubit,
              child: BlocListener<OnBoardingCreateEOACubit,
                  OnBoardingCreateEOAState>(
                listener: (context, state) {
                  switch (state.status) {
                    case OnBoardingCreateEOAStatus.creating:
                      break;
                    case OnBoardingCreateEOAStatus.created:
                      AppNavigator.replaceWith(
                        RoutePath.createNewWalletBackupPhrase,
                        state.auraWallet,
                      );
                      break;
                    case OnBoardingCreateEOAStatus.error:
                      _onError(state.error ?? '');
                      break;
                  }
                },
                child: PopScope(
                  canPop: false,
                  child: Scaffold(
                    backgroundColor: appTheme.bodyColorBackground,
                    appBar: AppBarWithOnlyTitle(
                      appTheme: appTheme,
                      titleKey: LanguageKey.onBoardingCreateEoaScreenAppBarTitle,
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
                              Text(
                                localization.translate(
                                  LanguageKey
                                      .onBoardingCreateEoaScreenCreatingNewWallet,
                                ),
                                style: AppTypoGraPhy.bodyMedium02.copyWith(
                                  color: appTheme.contentColor700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: BoxSize.boxSize02,
                              ),
                              Text(
                                localization.translate(
                                  LanguageKey.onBoardingCreateEoaScreenPleaseWait,
                                ),
                                style: AppTypoGraPhy.body01.copyWith(
                                  color: appTheme.contentColor500,
                                ),
                                textAlign: TextAlign.center,
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
      },
    );
  }

  void _onError(String error) async {
    showToast(error);

    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );

    AppNavigator.pop();
  }
}
