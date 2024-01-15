import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:pyxis_mobile/src/application/service/api_service_path.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service_impl.g.dart';

final class AuthApiServiceImpl implements AuthApiService{
  final AuthApiServiceGenerate _apiServiceGenerate;

  const AuthApiServiceImpl(this._apiServiceGenerate);
  @override
  Future<PyxisBaseResponse> signIn({required Map<String, dynamic> body}) {
    return _apiServiceGenerate.signIn(body);
  }
  
}
@RestApi()
abstract class AuthApiServiceGenerate{
  factory AuthApiServiceGenerate(Dio dio,{String ?baseUrl}) = _AuthApiServiceGenerate;

  @POST(ApiServicePath.authSignIn)
  Future<PyxisBaseResponse> signIn(@Body() Map<String,dynamic> body,);
}