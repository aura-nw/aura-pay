import 'package:data/data.dart';

abstract class NFTApiService {
  Future<BaseResponseV2> getNFTsByAddress({
    required Map<String, dynamic> body,
  });
}
