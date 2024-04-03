import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'backup_private_key_cubit.dart';
import 'backup_private_key_selector.dart';
import 'widgets/backup_private_key_form_widget.dart';
import 'widgets/backup_private_key_remind_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_button.dart';

class BackupPrivateKeyScreen extends StatefulWidget {
  final String address;

  const BackupPrivateKeyScreen({
    required this.address,
    super.key,
  });

  @override
  State<BackupPrivateKeyScreen> createState() => _BackupPrivateKeyScreenState();
}

class _BackupPrivateKeyScreenState extends State<BackupPrivateKeyScreen>
    with CustomFlutterToast {
  final BackupPrivateKeyCubit _cubit = getIt.get<BackupPrivateKeyCubit>();

  final HomeScreenObserver _homeScreenObserver =
      getIt.get<HomeScreenObserver>();

  void _emitBackUpPrivateKeySuccess() {
    _homeScreenObserver.emit(
      emitParam: HomeScreenEmitParam(
        event: HomeScreenObserver.backUpPrivateKeySuccess,
      ),
    );
  }

  @override
  void initState() {
    _cubit.init(
      onSuccess: _emitBackUpPrivateKeySuccess,
      address: widget.address,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _cubit,
          child: Scaffold(
            backgroundColor: appTheme.bodyColorBackground,
            appBar: AppBarWithTitle(
              appTheme: appTheme,
              titleKey: LanguageKey.backupPrivateKeyScreenAppBarTitle,
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
                        padding: EdgeInsets.zero,
                        children: [
                          BackupPrivateKeyRemindWidget(
                            appTheme: appTheme,
                          ),
                          const SizedBox(
                            height: BoxSize.boxSize07,
                          ),
                          BackupPrivateKeyFormWidget(
                            appTheme: appTheme,
                            onCopy: _onCopy,
                          ),
                        ],
                      ),
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return BackupPrivateKeyShowPrivateKeySelector(
                          builder: (showPrivateKey) {
                            return PrimaryAppButton(
                              text: !showPrivateKey
                                  ? localization.translate(
                                      LanguageKey
                                          .backupPrivateKeyScreenShowPrivateKeyButtonTitle,
                                    )
                                  : localization.translate(
                                      LanguageKey
                                          .backupPrivateKeyScreenGoHomeButtonTitle,
                                    ),
                              onPress: () => _onConfirm(showPrivateKey),
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onConfirm(bool showPrivateKey) {
    if (showPrivateKey) {
      AppNavigator.pop();
    } else {
      _cubit.showPrivateKey();
    }
  }

  void _onCopy(String privateKey) async {
    await Clipboard.setData(
      ClipboardData(text: privateKey),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.globalPyxisCopyMessage,
            {
              'value': 'private key',
            },
          ),
        );
      }
    }
  }
}
