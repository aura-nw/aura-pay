import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'transaction_api_service_impl.g.dart';

class TransactionApiServiceImpl implements TransactionApiService {
  final TransactionApiServiceGenerate _apiServiceGenerate;

  const TransactionApiServiceImpl(this._apiServiceGenerate);

  @override
  Future<TransactionBaseResponse> getTransaction({required Map<String,dynamic> queries}){
    return _apiServiceGenerate.getTransactions(queries);
  }

}

@RestApi()
abstract class TransactionApiServiceGenerate {
  factory TransactionApiServiceGenerate(Dio dio,{String ?baseUrl}) = _TransactionApiServiceGenerate;

  @GET(ApiServicePath.txs)
  Future<TransactionBaseResponse> getTransactions(@Queries() Map<String,dynamic> queries);
}
