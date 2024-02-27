import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/share_network.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'browser_event.dart';
import 'browser_bloc.dart';
import 'browser_selector.dart';
import 'widgets/browser_header_widget.dart';
import 'package:pyxis_mobile/src/presentation/widgets/dialog_provider_widget.dart';
import 'widgets/browser_bottom_navigator_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:screenshot/screenshot.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'widgets/change_account_form_widget.dart';

class BrowserScreen extends StatefulWidget {
  final String initUrl;

  const BrowserScreen({
    required this.initUrl,
    super.key,
  });

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late WebViewController _webViewController;

  late ScreenshotController _screenShotController;

  String? favicon;

  final BrowserBloc _bloc = getIt.get<BrowserBloc>();

  final HomeScreenObserver _homeScreenObserver =
      getIt.get<HomeScreenObserver>();

  void _runJavaScript() {
    _webViewController.runJavaScript('''
            var links = document.head.getElementsByTagName('link');
            for (var i = 0; i < links.length; i++) {
              if (links[i].rel == 'icon' || links[i].rel == 'shortcut icon' || links[i].rel == 'apple-touch-icon') {
                favicon.postMessage(links[i].href);
                break;
              }
            }
          ''');
  }

  void _onUrlChange(UrlChange change) async {
    final bool canGoNext = await _webViewController.canGoForward();
    _bloc.add(
      BrowserOnUrlChangeEvent(
        url: change.url ?? widget.initUrl,
        canGoNext: canGoNext,
      ),
    );

    // if(context.mounted){
    //   _screenShotController.captureAndSave(
    //     'directory',
    //     pixelRatio: context.ratio,
    //   );
    // }
  }


  @override
  void initState() {
    _bloc.add(
      BrowserOnInitEvent(
        url: widget.initUrl,
      ),
    );

    _screenShotController = ScreenshotController();
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            _runJavaScript();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onUrlChange: _onUrlChange,
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'favicon',
        onMessageReceived: (JavaScriptMessage message) {
          favicon = message.message;
        },
      )
      ..loadRequest(
        Uri.parse(
          widget.initUrl,
        ),
      );

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _webViewController = controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppThemeBuilder(
      builder: (appTheme) {
        return BlocProvider.value(
          value: _bloc,
          child: Scaffold(
            backgroundColor: appTheme.bodyColorBackground,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.spacing07,
                      vertical: Spacing.spacing06,
                    ),
                    child: BrowserUrlSelector(
                      builder: (url) {
                        return BrowserHeaderWidget(
                          appTheme: appTheme,
                          onViewTap: _onViewTabManagement,
                          onSearchTap: () {},
                          url: url,
                          onRefresh: _onRefreshPage,
                          onAddNewTab: _onAddNewTab,
                          onShareTap: _onShareBrowserPage,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Screenshot(
                      controller: _screenShotController,
                      child: WebViewWidget(
                        controller: _webViewController,
                      ),
                    ),
                  ),
                  BrowserBottomNavigatorWidget(
                    appTheme: appTheme,
                    onBack: _onBackClick,
                    onBookmarkClick: _onBookMarkClick,
                    onNext: _onNextClick,
                    onHomeClick: _onHomeClick,
                    onAccountClick: (accounts, selectedAccount) {
                      _showChoosingAccount(
                        appTheme,
                        accounts,
                        selectedAccount,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showChoosingAccount(
    AppTheme appTheme,
    List<AuraAccount> accounts,
    AuraAccount? selectedAccount,
  ) async {
    final account = await DialogProvider.showCustomDialog<AuraAccount>(
      context,
      appTheme: appTheme,
      widget: ChangeAccountFormWidget(
        accounts: accounts,
        appTheme: appTheme,
        isSelected: (account) {
          return selectedAccount?.id == account.id;
        },
      ),
      canBack: true,
    );

    if (account != null) {
      if (account.id == _bloc.state.selectedAccount?.id) return;

      _homeScreenObserver.emit(
        emitParam: HomeScreenEmitParam(
          event: HomeScreenObserver.onInAppBrowserChooseAccountEvent,
          data: account,
        ),
      );

      _bloc.add(
        BrowserOnRefreshAccountEvent(
          selectedAccount: account,
        ),
      );
    }
  }

  void _onBookMarkClick() async {
    final String? url = await _webViewController.currentUrl();
    final Uri uri = Uri.parse(url ?? widget.initUrl);

    String name = uri.query.isNotEmpty ? uri.query : uri.host;

    _bloc.add(
      BrowserOnBookMarkClickEvent(
        name: name,
        url: widget.initUrl,
        logo: favicon ?? '',
      ),
    );
  }

  void _onHomeClick() {
    AppNavigator.popUntil(
      RoutePath.home,
    );
  }

  void _onNextClick() async {
    if (await _webViewController.canGoForward()) {
      await _webViewController.goForward();
    }
  }

  void _onBackClick() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
    } else {
      AppNavigator.pop();
    }
  }

  void _onShareBrowserPage() async {
    final url = await _webViewController.currentUrl();

    await ShareNetWork.shareBrowser(
      url ?? widget.initUrl,
    );
  }

  void _onAddNewTab() {
    _bloc.add(
      const BrowserOnAddNewBrowserEvent(
        url: 'https://www.google.com/search',
        siteName: 'Google search',
        logo: '',
        browserImage: '',
      ),
    );
  }

  void _onRefreshPage() async {
    await _webViewController.reload();
  }

  void _onViewTabManagement() {
    AppNavigator.push(
      RoutePath.browserTabManagement,
    );
  }
}
