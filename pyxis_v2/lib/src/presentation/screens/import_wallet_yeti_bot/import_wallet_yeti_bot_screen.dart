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
import 'import_wallet_yeti_bot_state.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_button.dart';
import 'package:pyxis_v2/src/presentation/widgets/yeti_bot_message_widget.dart';
import 'import_wallet_yeti_bot_cubit.dart';
import 'import_yeti_bot_selector.dart';
import 'widgets/app_bar_title.dart';
import 'package:pyxis_v2/src/presentation/widgets/app_bar_widget.dart';
import 'package:pyxis_v2/src/presentation/widgets/base_screen.dart';
import 'package:wallet_core/wallet_core.dart';

class ImportWalletYetiBotScreen extends StatefulWidget {
  final AWallet aWallet;

  const ImportWalletYetiBotScreen({
    required this.aWallet,
    super.key,
  });

  @override
  State<ImportWalletYetiBotScreen> createState() =>
      _ImportWalletYetiBotScreenState();
}

class _ImportWalletYetiBotScreenState extends State<ImportWalletYetiBotScreen>
    with StateFulBaseScreen {
  final List<YetiBotMessageObject> _messages = [];

  late ImportWalletYetiBotCubit _cubit;

  final GlobalKey<AnimatedListState> _messageKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    _cubit = getIt.get<ImportWalletYetiBotCubit>(
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
          LanguageKey.importWalletYetiBotScreenBotContentOne,
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
          LanguageKey.importWalletYetiBotScreenBotContentTwo,
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
          LanguageKey.importWalletYetiBotScreenBotContentThree,
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
          LanguageKey.importWalletYetiBotScreenBotContentFour,
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
          LanguageKey.importWalletYetiBotScreenBotContentFive,
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
        ImportWalletYetiBotIsReadySelector(
          builder: (isReady) {
            return PrimaryAppButton(
              onPress: _onNavigateToHome,
              text: !isReady
                  ? localization.translate(
                      LanguageKey.importWalletYetiBotScreenGenerating,
                    )
                  : localization.translate(
                      LanguageKey.importWalletYetiBotScreenOnBoard,
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
      child: BlocListener<ImportWalletYetiBotCubit, ImportWalletYetiBotState>(
        listener: (context, state) {
          switch (state.status) {
            case ImportWalletYetiBotStatus.none:
              break;
            case ImportWalletYetiBotStatus.storing:
              // Show loading
              break;
            case ImportWalletYetiBotStatus.stored:
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
            title: ImportWalletYetiBotAppBarTitleWidget(
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
