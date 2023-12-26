import 'dart:developer';

import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'transaction_api_service_impl.g.dart';

class TransactionApiServiceImpl implements TransactionApiService {
  final TransactionApiServiceGenerate _apiServiceGenerate;

  const TransactionApiServiceImpl(this._apiServiceGenerate);

  @override
  Future<BaseResponseV2> getTransaction({
    required Map<String, dynamic> body,
  }) {
    return _apiServiceGenerate.getTransactions(body);
  }

  @override
  Future<BaseResponseV2> getTransactionDetail({
    required Map<String, dynamic> body,
  }) {
    return _apiServiceGenerate.getTransactionDetail(body);
  }
}

@RestApi()
abstract class TransactionApiServiceGenerate {
  factory TransactionApiServiceGenerate(Dio dio, {String? baseUrl}) =
      _TransactionApiServiceGenerate;

  @POST(ApiServicePath.graphiql)
  Future<BaseResponseV2> getTransactions(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiServicePath.graphiql)
  Future<BaseResponseV2> getTransactionDetail(
    @Body() Map<String, dynamic> body,
  );
}
