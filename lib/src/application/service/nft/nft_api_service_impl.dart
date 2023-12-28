import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'nft_api_service_impl.g.dart';

final class NFTApiServiceImpl implements NFTApiService {
  final NFTApiServiceGenerate _nftApiServiceGenerate;

  const NFTApiServiceImpl(this._nftApiServiceGenerate);
  @override
  Future<BaseResponseV2> getNFTsByAddress({
    required Map<String, dynamic> body,
  }) {
    return _nftApiServiceGenerate.getNFTs(body);
  }
}

@RestApi()
abstract class NFTApiServiceGenerate {
  factory NFTApiServiceGenerate(Dio dio, {String? baseUrl}) =
      _NFTApiServiceGenerate;

  @POST(ApiServicePath.graphiql)
  Future<BaseResponseV2> getNFTs(
    @Body() Map<String, dynamic> body,
  );
}
