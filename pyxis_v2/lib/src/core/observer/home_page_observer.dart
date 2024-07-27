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


  @override
  void emit({
    required HomeScreenEmitParam emitParam,
  }) {
    for (final listener in listeners) {
      listener.call(emitParam);
    }
  }
}
