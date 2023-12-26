import 'package:data/src/data/dto/nft_information_dto.dart';
import 'package:data/src/data/resource/remote/api_service.dart';
import 'package:domain/domain.dart';

final class NFTRepositoryImpl implements NFTRepository {
  final NFTApiService _nftApiService;

  const NFTRepositoryImpl(this._nftApiService);

  @override
  Future<NFTsInformation> getNFTsByAddress({
    required Map<String, dynamic> body,
    required String environment,
  }) async {
    final response = await _nftApiService.getNFTsByAddress(
      body: body,
    );

    final data = response.handleResponse();

    final Map<String,dynamic> dataFromEnvironment = data[environment] ?? {};

    final NFTsInformationDto nfTsInformationDto = NFTsInformationDto.fromJson(dataFromEnvironment);

    return nfTsInformationDto.toEntity();
  }
}
