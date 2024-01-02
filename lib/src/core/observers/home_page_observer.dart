import 'observer_base.dart';

typedef HomeListener = void Function(Map<String,dynamic>);

final class HomeScreenObserver
    extends ObserverBase<HomeListener, Map<String,dynamic>> {
  static String onListenAccountChangeEvent = 'ON_LISTEN_ACCOUNT_CHANGE_EVENT';
  static String onSelectedAccountChangeEvent = 'ON_SELECTED_ACCOUNT_CHANGE_EVENT';
  static String onHomePageDropdownClickEvent = 'ON_HOME_PAGE_DROP_DOWN_CLICK_EVENT';

  @override
  void emit({
    required Map<String,dynamic> emitParam,
  }) {
    for (final listener in listeners) {
      listener.call(emitParam);
    }
  }
}