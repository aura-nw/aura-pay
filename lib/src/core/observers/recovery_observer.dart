import 'observer_base.dart';

typedef RecoveryListener = void Function(bool, String?);

final class RecoveryEmitParam {
  final bool status;
  final String? msg;

  const RecoveryEmitParam({
    required this.status,
    this.msg,
  });
}

final class RecoveryObserver
    extends ObserverBase<RecoveryListener, RecoveryEmitParam> {
  @override
  void emit({
    required RecoveryEmitParam emitParam,
  }) {
    for (final listener in listeners) {
      listener.call(emitParam.status, emitParam.msg);
    }
  }
}
