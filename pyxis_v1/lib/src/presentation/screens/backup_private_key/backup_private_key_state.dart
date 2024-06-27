import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_private_key_state.freezed.dart';

@freezed
class BackupPrivateKeyState with _$BackupPrivateKeyState {
  const factory BackupPrivateKeyState({
    @Default(false) bool showPrivateKey,
    @Default('') String privateKey,
  }) = _BackupPrivateKeyState;
}
