import 'package:domain/src/domain/entities/entities.dart';

abstract interface class NFTRepository {
  Future<NFTsInformation> getNFTsByAddress({
    required Map<String, dynamic> body,
    required String environment,
  });
}
