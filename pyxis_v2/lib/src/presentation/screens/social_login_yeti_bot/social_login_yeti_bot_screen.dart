import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyxis_v2/app_configs/di.dart';
import 'package:pyxis_v2/src/application/global/app_global_state/app_global_cubit.dart';
import 'package:pyxis_v2/src/application/global/app_global_state/app_global_state.dart';
import 'package:pyxis_v2/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_v2/src/application/global/localization/localization_manager.dart';
import 'package:pyxis_v2/src/core/constants/language_key.dart';
import 'package:pyxis_v2/src/core/constants/size_constant.dart';
import 'package:pyxis_v2/src/core/utils/dart_core_extension.dart';
import 'social_login_yeti_bot_state.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';
import 'package:pyxis_v2/src/presentation/widgets/yeti_bot_message_widget.dart';
import 'social_login_yeti_bot_cubit.dart';
import 'social_login_yeti_bot_selector.dart';
import 'widgets/app_bar_title.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';
import 'package:wallet_core/wallet_core.dart';

class SocialLoginYetiBotScreen extends StatefulWidget {
  final AWallet aWallet;

  const SocialLoginYetiBotScreen({
    required this.aWallet,
    super.key,
  });

  @override
  State<SocialLoginYetiBotScreen> createState() =>
      _SocialLoginYetiBotScreenState();
}

class _SocialLoginYetiBotScreenState extends State<SocialLoginYetiBotScreen>
    with StateFulBaseScreen {
  final List<YetiBotMessageObject> _messages = [];

  late SocialLoginYetiBotCubit _cubit;

  final GlobalKey<AnimatedListState> _messageKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _cubit = getIt.get<SocialLoginYetiBotCubit>(
      param1: widget.aWallet,
    );
    super.initState();
  }

  void _addContent() async {
    final localization = AppLocalizationManager.of(context);

    await Future.delayed(
      const Duration(
        milliseconds: 1200,
      ),
    );

    _messages.insert(
      0,
      YetiBotMessageObject(
        data: localization.translate(
          LanguageKey.socialLoginYetiBotScreenBotContentOne,
        ),
        groupId: 0,
        type: 0,
      ),
    );

    _messageKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );

    await Future.delayed(
      const Duration(
        milliseconds: 1200,
      ),
    );
    _messages.insert(
      0,
      YetiBotMessageObject(
        data: localization.translate(
          LanguageKey.socialLoginYetiBotScreenBotContentTwo,
        ),
        groupId: 0,
        type: 0,
      ),
    );

    _messageKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );

    await Future.delayed(
      const Duration(
        milliseconds: 1200,
      ),
    );

    _messages.insert(
      0,
      YetiBotMessageObject(
        data: localization.translate(
          LanguageKey.socialLoginYetiBotScreenBotContentThree,
        ),
        groupId: 0,
        type: 0,
      ),
    );

    _messageKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );

    await Future.delayed(
      const Duration(
        milliseconds: 1200,
      ),
    );

    _messages.insert(
      0,
      YetiBotMessageObject(
        data: localization.translate(
          LanguageKey.socialLoginYetiBotScreenBotContentFour,
        ),
        groupId: 1,
        type: 0,
      ),
    );
    _messageKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );

    await Future.delayed(
      const Duration(
        milliseconds: 1200,
      ),
    );

    _messages.insert(
      0,
      YetiBotMessageObject(
        data: localization.translate(
          LanguageKey.socialLoginYetiBotScreenBotContentFive,
        ),
        groupId: 2,
        type: 1,
        object: _cubit.state.wallet.address,
      ),
    );

    _messageKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );

    _cubit.updateStatus(true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addContent();
  }

  @override
  void dispose() {
    _messages.clear();

    _messageKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget child(BuildContext context, AppTheme appTheme,
      AppLocalizationManager localization) {
    return Column(
      children: [
        Expanded(
          child: AnimatedList(
            key: _messageKey,
            padding: const EdgeInsets.symmetric(
              vertical: Spacing.spacing06,
            ),
            reverse: true,
            initialItemCount: _messages.length,
            primary: true,
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                sizeFactor: animation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Spacing.spacing03,
                  ),
                  child: YetiBotMessageBuilder(
                    appTheme: appTheme,
                    messageObject: _messages[index],
                    nextGroup: _messages.getIndex(index + 1)?.groupId,
                    onTap: () {},
                    localization: localization,
                    lastGroup: _messages.getIndex(index - 1)?.groupId,
                  ),
                ),
              );
            },
          ),
        ),
        SocialLoginYetiBotIsReadySelector(
          builder: (isReady) {
            return PrimaryAppButton(
              onPress: _onNavigateToHome,
              text: !isReady
                  ? localization.translate(
                      LanguageKey.socialLoginYetiBotScreenGenerating,
                    )
                  : localization.translate(
                      LanguageKey.socialLoginYetiBotScreenOnBoard,
                    ),
              isDisable: !isReady,
              leading: !isReady
                  ? SizedBox.square(
                      dimension: 19.2,
                      child: CircularProgressIndicator(
                        color: appTheme.textDisabled,
                      ),
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget wrapBuild(BuildContext context, Widget child, AppTheme appTheme,
      AppLocalizationManager localization) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<SocialLoginYetiBotCubit, SocialLoginYetiBotState>(
        listener: (context, state) {
          switch (state.status) {
            case SocialLoginYetiBotStatus.none:
              break;
            case SocialLoginYetiBotStatus.storing:
              // Show loading
              break;
            case SocialLoginYetiBotStatus.stored:
              AppGlobalCubit.of(context).changeStatus(
                AppGlobalStatus.authorized,
              );
              break;
          }
        },
        child: Scaffold(
          backgroundColor: appTheme.bgSecondary,
          appBar: AppBarDefault(
            appTheme: appTheme,
            localization: localization,
            title: SocialLoginYetiBotAppBarTitleWidget(
              appTheme: appTheme,
              localization: localization,
            ),
          ),
          body: child,
        ),
      ),
    );
  }

  void _onNavigateToHome() {
    _cubit.storeKey();
  }
}
