import 'dart:developer';

import 'package:data/src/data/resource/remote/api_service.dart';
import 'package:domain/domain.dart';

final class FeeGrantRepositoryImpl implements FeeGrantRepository {
  final GrantFeeApiService _apiService;

  const FeeGrantRepositoryImpl(this._apiService);

  @override
  Future<void> grantFee({
    required Map<String, dynamic> body,
    String? baseUrl,
  }) async {
    final baseResponse = await _apiService.grantFee(
      body: body,
    );

    log(baseResponse.data.toString());

    baseResponse.handleResponse();
  }
}
