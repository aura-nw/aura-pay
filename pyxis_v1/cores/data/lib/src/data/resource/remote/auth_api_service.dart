import 'package:data/src/core/base_response.dart';

abstract interface class AuthApiService {
  Future<PyxisBaseResponse> signIn({
    required Map<String, dynamic> body,
  });
}
