import 'package:data/data.dart';

abstract class NFTApiService {
  Future<AuraBaseResponseV2> getNFTsByAddress({
    required Map<String, dynamic> body,
  });
}
