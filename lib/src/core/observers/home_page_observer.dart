import 'observer_base.dart';

typedef HomeListener = void Function(HomeScreenEmitParam data);

final class HomeScreenEmitParam<T> {
  final String event;
  final T ?data;

  const HomeScreenEmitParam({
    required this.event,
    this.data,
  });
}

final class HomeScreenObserver
    extends ObserverBase<HomeListener, HomeScreenEmitParam> {
  static String createSmartAccountSuccessfulEvent =
      'CREATE_SMART_ACCOUNT_SUCCESSFUL_EVENT';
  static String importAccountSuccessfulEvent =
      'IMPORT_ACCOUNT_SUCCESSFUL_EVENT';
  static String recoverAccountSuccessfulEvent =
      'RECOVER_ACCOUNT_SUCCESSFUL_EVENT';
  static String onListenAccountChangeEvent = 'ON_LISTEN_ACCOUNT_CHANGE_EVENT';
  static String onSelectedAccountChangeEvent =
      'ON_SELECTED_ACCOUNT_CHANGE_EVENT';
  static String onSendTokenSuccessFulEvent =
      'ON_SEND_TOKEN_SUCCESSFUL_EVENT';
  static String onSetRecoveryMethodSuccessfulEvent = 'ON_SET_RECOVERY_METHOD_SUCCESSFUL_EVENT';
  static String onRecoverSuccessfulEvent = 'ON_RECOVER_SUCCESSFUL_EVENT';
  static String onInAppBrowserChooseAccountEvent = 'ON_IN_APP_BROWSER_CHOOSE_ACCOUNT_EVENT';
  static String onInAppBrowserRefreshBookMarkEvent = 'ON_IN_APP_BROWSER_REFRESH_BOOKMARK_EVENT';
  static String onInAppBrowserRefreshBrowserEvent = 'ON_IN_APP_BROWSER_REFRESH_BROWSER_EVENT';
  static String onConnectWalletChooseAccountEvent = 'ON_CONNECT_WALLET_CHOOSE_ACCOUNT_EVENT';

  @override
  void emit({
    required HomeScreenEmitParam emitParam,
  }) {
    for (final listener in listeners) {
      listener.call(emitParam);
    }
  }
}
