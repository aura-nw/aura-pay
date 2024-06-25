import 'package:domain/src/domain/entities/entities.dart';
import 'package:domain/src/domain/entities/requests/request.dart';
import 'package:domain/src/domain/repository/nft_repository.dart';

final class NFTUseCase {
  final NFTRepository _repository;

  const NFTUseCase(this._repository);

  Future<NFTsInformation> getNFTsByAddress({
    required String owner,
    required String environment,
    required int offset,
    required int limit,
  }) async {
    return _repository.getNFTsByAddress(
      body: QueryNFTByAddressParameter(
        environment: environment,
        owner: owner,
        offset: offset,
        limit: limit,
      ).toJson(),
      environment: environment,
    );
  }
}
