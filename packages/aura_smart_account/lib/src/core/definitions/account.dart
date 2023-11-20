import 'package:aura_smart_account/src/proto/google/protobuf/export.dart';

class Account<T> {
  final String typeUrl;
  final Any Function(Any any) pubKey;

  const Account({
    required this.typeUrl,
    required this.pubKey,
  });

}
