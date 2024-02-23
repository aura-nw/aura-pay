import 'package:flutter/material.dart';
import 'package:pyxis_mobile/src/application/global/app_theme/app_theme_builder.dart';
import 'package:pyxis_mobile/src/aura_navigator.dart';
import 'package:pyxis_mobile/src/core/constants/size_constant.dart';
import 'package:pyxis_mobile/src/presentation/screens/browser/widgets/browser_header_widget.dart';
import 'widgets/browser_bottom_navigator_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

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

  String ?favicon;

  @override
  void initState() {
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
          onProgress: (int progress) {

          },
          onPageStarted: (String url) {

          },
          onPageFinished: (String url) {
            _webViewController.runJavaScript('''
            var links = document.head.getElementsByTagName('link');
            for (var i = 0; i < links.length; i++) {
              if (links[i].rel == 'icon' || links[i].rel == 'shortcut icon') {
                channels.favicon.postMessage(links[i].href);
                break;
              }
            }
          ''');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {


          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'favicon',
        onMessageReceived: (JavaScriptMessage message) {
          favicon = message.message;
          debugPrint('receive icon $favicon');
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
        return Scaffold(
          backgroundColor: appTheme.bodyColorBackground,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.spacing07,
                    vertical: Spacing.spacing06,
                  ),
                  child: BrowserHeaderWidget(
                    appTheme: appTheme,
                    onViewTap: () {},
                    onSearchTap: () {},
                    url: widget.initUrl,
                    onMoreTap: () {

                    },
                  ),
                ),
                Expanded(
                  child: WebViewWidget(
                    controller: _webViewController,
                  ),
                ),
                BrowserBottomNavigatorWidget(
                  appTheme: appTheme,
                  onBack: () {
                    AppNavigator.pop();
                  },
                  onBookmarkClick: () {},
                  onNext: () {},
                  onHomeClick: () {
                    AppNavigator.popUntil(
                      RoutePath.home,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
