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
  static String onHomePageDropdownClickEvent =
      'ON_HOME_PAGE_DROP_DOWN_CLICK_EVENT';

  @override
  void emit({
    required HomeScreenEmitParam emitParam,
  }) {
    for (final listener in listeners) {
      listener.call(emitParam);
    }
  }
}
