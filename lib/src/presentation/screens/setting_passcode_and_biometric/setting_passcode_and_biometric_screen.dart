import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/asset_path.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/utils/debounce.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'package:pyxis_mobile/src/presentation/screens/setting_passcode_and_biometric/setting_passcode_and_biometric_cubit.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/switch_widget.dart';

import 'setting_passcode_and_biometric_selector.dart';
import 'widgets/setting_secure_option.dart';

class SettingPasscodeAndBiometricScreen extends StatefulWidget {
  const SettingPasscodeAndBiometricScreen({super.key});

  @override
  State<SettingPasscodeAndBiometricScreen> createState() =>
      _SettingPasscodeAndBiometricScreenState();
}

class _SettingPasscodeAndBiometricScreenState
    extends State<SettingPasscodeAndBiometricScreen> with CustomFlutterToast {
  final SettingPasscodeAndBiometricCubit _cubit =
      getIt.get<SettingPasscodeAndBiometricCubit>();

  final Denounce<bool> _denounce = Denounce(
    const Duration(
      milliseconds: 1200,
    ),
  );

  void _onSetBioMetric(bool value) {
    _cubit.updateBio(value);
  }

  @override
  void initState() {
    _denounce.addObserver(_onSetBioMetric);
    super.initState();
  }

  @override
  void dispose() {
    _denounce.removeObserver(_onSetBioMetric);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _cubit,
          child: Scaffold(
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey:
                  LanguageKey.settingChangePasscodeAndBioScreenAppBarTitle,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.spacing07,
              ),
              child: Column(
                children: [
                  SettingSecureOptionWidget(
                    iconPath: AssetIconPath.settingBioAndPassCodeBio,
                    labelPath: LanguageKey
                        .settingChangePasscodeAndBioScreenChangePasscode,
                    appTheme: appTheme,
                    onTap: () async {
                      final status = await AppNavigator.push(
                        RoutePath.settingChangePassCode,
                      );

                      if (status == true && context.mounted) {
                        showSuccessToast(
                          AppLocalizationManager.of(context).translate(
                            LanguageKey
                                .settingChangePasscodeAndBioScreenSetNewPassCodeSuccessful,
                          ),
                        );
                      }
                    },
                    prefix: SvgPicture.asset(
                      AssetIconPath.commonArrowNext,
                    ),
                  ),
                  SettingSecureOptionWidget(
                    iconPath: AssetIconPath.settingBioAndPassCodeBio,
                    labelPath:
                        LanguageKey.settingChangePasscodeAndBioScreenFaceId,
                    appTheme: appTheme,
                    onTap: () {},
                    prefix: SettingPassCodeAndBioMetricAlReadyBioSelector(
                        builder: (isSelected) {
                      return SwitchWidget(
                        onChanged: (value) {
                          _cubit.onSetBio();

                          _denounce.onDenounce(value);
                        },
                        isSelected: isSelected,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
