import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'backup_private_key_cubit.dart';
import 'backup_private_key_state.dart';

class BackupPrivateKeyShowPrivateKeySelector
    extends BlocSelector<BackupPrivateKeyCubit, BackupPrivateKeyState, bool> {
  BackupPrivateKeyShowPrivateKeySelector({
    Key? key,
    required Widget Function(bool) builder,
  }) : super(
          key: key,
          selector: (state) => state.showPrivateKey,
          builder: (_, showPrivateKey) => builder(
            showPrivateKey,
          ),
        );
}

class BackupPrivateKeyPrivateKeySelector
    extends BlocSelector<BackupPrivateKeyCubit, BackupPrivateKeyState, String> {
  BackupPrivateKeyPrivateKeySelector({
    Key? key,
    required Widget Function(String) builder,
  }) : super(
          key: key,
          selector: (state) => state.privateKey,
          builder: (_, privateKey) => builder(
            privateKey,
          ),
        );
}
