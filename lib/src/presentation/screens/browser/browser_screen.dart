import 'dart:io';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pyxis_mobile/app_configs/di.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/core/helpers/share_network.dart';
import 'package:pyxis_mobile/src/core/observers/home_page_observer.dart';
import 'package:pyxis_mobile/src/core/utils/context_extension.dart';
import 'package:pyxis_mobile/src/core/utils/debounce.dart';
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

class BrowserScreenOptionArgument {
  final BrowserOpenType browserOpenType;
  final int? choosingId;

  const BrowserScreenOptionArgument({
    this.browserOpenType = BrowserOpenType.normal,
    this.choosingId,
  });
}

class BrowserScreen extends StatefulWidget {
  final String initUrl;
  final BrowserScreenOptionArgument option;

  const BrowserScreen({
    required this.initUrl,
    required this.option,
    super.key,
  });

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late WebViewController _webViewController;

  late ScreenshotController _screenShotController;

  late Denounce<String> _denounce;

  String? favicon;
  String? preUrl;

  final String _googleSearchUrl = 'https://www.google.com/search';

  late BrowserBloc _bloc;

  final HomeScreenObserver _homeScreenObserver =
      getIt.get<HomeScreenObserver>();

  Future<void> _runJavaScript() async {
    return _webViewController.runJavaScript('''
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
    favicon = null;
    if (change.url == preUrl) return;

    preUrl = change.url;

    _denounce.onDenounce(
      change.url ?? widget.initUrl,
    );
  }

  Future<String?> _screenShot() async {
    final currentBrowser = _bloc.state.currentBrowser;

    if (currentBrowser != null) {
      final directory = await getApplicationDocumentsDirectory();

      File file = File(currentBrowser.screenShotUri);

      if (await file.exists()) {
        await file.delete();
      }

      if (context.mounted) {
        return _screenShotController.captureAndSave(
          directory.path,
          pixelRatio: context.ratio,
          fileName:
              '${currentBrowser.siteTitle.replaceAll(' ', '')}_${currentBrowser.id}',
        );
      }
    }

    return null;
  }

  WebViewController _initWebViewController() {
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
          onPageStarted: (String url) {
            favicon = null;
          },
          onPageFinished: (String url) {},
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
      );

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    return controller;
  }

  void _urlChangeObserver(String url) async {
    await _runJavaScript();

    final bool canGoNext = await _webViewController.canGoForward();

    final String? title = await _webViewController.getTitle();

    final String? path = await _screenShot();

    _bloc.add(
      BrowserOnUrlChangeEvent(
        url: url,
        canGoNext: canGoNext,
        title: title,
        logo: favicon,
        imagePath: path,
      ),
    );
  }

  @override
  void initState() {
    _denounce = Denounce(
      const Duration(
        seconds: 3,
      ),
    )..addObserver(_urlChangeObserver);

    _bloc = getIt.get<BrowserBloc>(
      param1: widget.option,
      param2: widget.initUrl,
    );

    _bloc.add(
      const BrowserOnInitEvent(),
    );

    _webViewController = _initWebViewController();

    _webViewController.loadRequest(
      Uri.parse(
        widget.initUrl,
      ),
    );

    _screenShotController = ScreenshotController();
    super.initState();
  }

  @override
  void dispose() {
    _denounce.removeObserver(_urlChangeObserver);
    _denounce.disPose();
    super.dispose();
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

    String? title = await _webViewController.getTitle();

    if (title == null) {
      final Uri uri = Uri.parse(url ?? widget.initUrl);

      title = uri.query.isNotEmpty ? uri.query : uri.host;
    }

    _bloc.add(
      BrowserOnBookMarkClickEvent(
        name: title,
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

  void _onAddNewTab() async {
    _bloc.add(
      BrowserOnAddNewBrowserEvent(
        url: _googleSearchUrl,
        siteName: 'Google search',
        logo: '',
        browserImage: '',
      ),
    );

    _webViewController.loadRequest(
      Uri.parse(
        _googleSearchUrl,
      ),
    );
  }

  void _onRefreshPage() async {
    await _webViewController.reload();
  }

  void _onViewTabManagement() async {
    final Map<String, dynamic>? result = await AppNavigator.push(
      RoutePath.browserTabManagement,
      false,
    );

    if (result != null) {
      final int? id = result['id'];

      if (id != null && id == _bloc.state.currentBrowser?.id) return;

      _webViewController = _initWebViewController();

      final String url = result['url'];

      final BrowserOpenType type = result['type'];

      _bloc.add(
        BrowserOnReceivedTabResultEvent(
          url: url,
          option: BrowserScreenOptionArgument(
            choosingId: id,
            browserOpenType: type,
          ),
        ),
      );

      _webViewController.loadRequest(
        Uri.parse(
          url,
        ),
      );
    }
  }
}
