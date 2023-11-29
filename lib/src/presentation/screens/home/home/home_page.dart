import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_mobile/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/application/global/localization/app_localization_provider.dart';
import 'package:pyxis_mobile/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/language_key.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/constants/typography.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/toast.dart';
import 'widgets/account_card_widget.dart';
import 'widgets/chain_trigger_widget.dart';
import 'widgets/empty_token_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with CustomFlutterToast, TickerProviderStateMixin {
  late AnimationController _receiveWidgetController;
  late Animation _receiveAnimation;

  @override
  void initState() {
    _receiveWidgetController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 450,
      ),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _receiveAnimation = Tween<double>(
      begin: -context.h,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _receiveWidgetController,
        curve: Curves.easeOutSine,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return Stack(
          children: [
            Scaffold(
              appBar: HomeAppBarWidget(
                appTheme: appTheme,
                onNotificationTap: () {},
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.spacing07,
                  vertical: Spacing.spacing04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AppGlobalCubit, AppGlobalState>(
                      bloc: AppGlobalCubit.of(context),
                      builder: (context, state) {
                        return AccountCardWidget(
                          address: state.accounts.first.address,
                          accountName: state.accounts.first.accountName,
                          appTheme: appTheme,
                          onShowMoreAccount: () {},
                          onCopy: _copyAddress,
                        );
                      },
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize07,
                    ),
                    ChainTriggerWidget(
                      appTheme: appTheme,
                      onNFTsTap: () {},
                      onReceiveTap: () {},
                      onSendTap: () async {
                        await AppNavigator.push(
                          RoutePath.sendTransaction,
                        );
                      },
                      onStakeTap: () {},
                      onTXsLimitTap: () {},
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppLocalizationProvider(
                          builder: (localization, _) {
                            return Text(
                              localization.translate(
                                LanguageKey.homePageTotalTokensValue,
                              ),
                              style: AppTypoGraPhy.body02.copyWith(
                                color: appTheme.contentColor500,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize02,
                    ),
                    AppLocalizationProvider(
                      builder: (localization, _) {
                        return RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: localization.translate(
                                  LanguageKey.homePageTokenPrefix,
                                ),
                                style: AppTypoGraPhy.heading03.copyWith(
                                  color: appTheme.contentColorBrand,
                                ),
                              ),
                              TextSpan(
                                text: '  0.00',
                                style: AppTypoGraPhy.heading03.copyWith(
                                  color: appTheme.contentColor700,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: BoxSize.boxSize09,
                    ),
                    Center(
                      child: EmptyTokenWidget(
                        appTheme: appTheme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _copyAddress(String data) async {
    await Clipboard.setData(
      ClipboardData(text: data),
    );

    if (Platform.isIOS) {
      if (context.mounted) {
        showToast(
          AppLocalizationManager.of(context).translateWithParam(
            LanguageKey.globalPyxisCopyMessage,
            {
              'value': 'address',
            },
          ),
        );
      }
    }
  }
}
