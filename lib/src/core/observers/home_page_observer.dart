import 'observer_base.dart';

typedef HomeListener = void Function(bool status);

final class HomePageObserver
    extends ObserverBase<HomeListener, bool> {
  @override
  void emit({
    required bool emitParam,
  }) {
    for (final listener in listeners) {
      listener.call(emitParam);
    }
  }
}