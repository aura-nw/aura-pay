typedef RecoveryListener = void Function(bool, String?);

final class RecoveryObserver {
  final List<RecoveryListener> _listeners = List.empty(growable: true);

  void addListener(RecoveryListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(RecoveryListener listener) {
    if (_listeners.contains(listener)) {
      _listeners.remove(listener);
    }
  }

  void clear() {
    _listeners.clear();
  }

  void emit({
    required bool status,
    String? msg,
  }) {
    for (final listener in _listeners) {
      listener.call(status, msg);
    }
  }
}
