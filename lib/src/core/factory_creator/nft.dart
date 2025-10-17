import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:aurapay/src/application/provider/service/nft/nft_service_impl.dart';

NftUseCase nftUseCaseFactory(Dio dio) {
  return NftUseCase(
    NftRepositoryImpl(
      NftServiceImpl(
        NFTServiceGenerator(dio),
      ),
    ),
  );
}
