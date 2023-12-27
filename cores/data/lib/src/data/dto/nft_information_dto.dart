import 'package:domain/domain.dart';

extension NFTsInformationDtoToEntity on NFTsInformationDto {
  NFTsInformation toEntity() {
    return NFTsInformation(
      cw721Tokens: cw721Tokens
          .map(
            (dto) => dto.toEntity(),
          )
          .toList(),
      count: count,
    );
  }
}

extension NFTInformationDtoToEntity on NFTInformationDto {
  NFTInformation toEntity() {
    return NFTInformation(
      id: id,
      tokenId: tokenId,
      mediaInfo: mediaInfo.toEntity(),
      lastUpdatedHeight: lastUpdatedHeight,
      createdAt: createdAt,
      cw721Contract: cw721Contract.toEntity(),
    );
  }
}

extension MediaInfoDtoToEntity on MediaInfoDto {
  MediaInfo toEntity() {
    return MediaInfo(
      onChain: onChain.toEntity(),
      offChain: offChain.toEntity(),
    );
  }
}

extension OnChainMediaInfoDtoToEntity on OnChainMediaInfoDto {
  OnChainMediaInfo toEntity() {
    return OnChainMediaInfo(
      tokenUri: tokenUri,
    );
  }
}

extension OffChainMediaInfoDtoToEntity on OffChainMediaInfoDto {
  OffChainMediaInfo toEntity() {
    return OffChainMediaInfo(
      image: image.toEntity(),
      animation: animation?.toEntity(),
    );
  }
}

extension ImageInfoDtoToEntity on ImageInfoDto {
  ImageInfo toEntity() {
    return ImageInfo(
      url: url,
      contentType: contentType,
    );
  }
}


extension AnimationInfoDtoToEntity on AnimationInfoDto {
  AnimationInfo toEntity() {
    return AnimationInfo(
      url: url,
      contentType: contentType,
    );
  }
}

extension CW721ContractDtoToEntity on CW721ContractDto {
  CW721Contract toEntity() {
    return CW721Contract(
      name: name,
      symbol: symbol,
      smartContract: smartContract.toEntity(),
    );
  }
}

extension SmartContractDtoToEntity on SmartContractDto {
  SmartContract toEntity() {
    return SmartContract(
      name: name,
      address: address,
    );
  }
}

final class NFTsInformationDto {
  final List<NFTInformationDto> cw721Tokens;
  final int count;

  const NFTsInformationDto({
    required this.cw721Tokens,
    required this.count,
  });

  factory NFTsInformationDto.fromJson(Map<String, dynamic> json) {
    return NFTsInformationDto(
      cw721Tokens: (json['cw721_token'] as List<dynamic>)
          .map((token) => NFTInformationDto.fromJson(token))
          .toList(),
      count: Map<String, dynamic>.from(
            json['cw721_token_aggregate'] ?? {},
          )['aggregate']?['count'] ??
          0,
    );
  }
}

final class NFTInformationDto {
  final int id;
  final String tokenId;
  final MediaInfoDto mediaInfo;
  final int lastUpdatedHeight;
  final DateTime createdAt;
  final CW721ContractDto cw721Contract;

  const NFTInformationDto({
    required this.id,
    required this.tokenId,
    required this.mediaInfo,
    required this.lastUpdatedHeight,
    required this.createdAt,
    required this.cw721Contract,
  });

  factory NFTInformationDto.fromJson(Map<String, dynamic> json) {
    return NFTInformationDto(
      id: json['id'],
      tokenId: json['token_id'],
      mediaInfo: MediaInfoDto.fromJson(
        json['media_info'],
      ),
      lastUpdatedHeight: json['last_updated_height'],
      createdAt: DateTime.parse(
        json['created_at'],
      ),
      cw721Contract: CW721ContractDto.fromJson(
        json['cw721_contract'],
      ),
    );
  }
}

final class MediaInfoDto {
  final OnChainMediaInfoDto onChain;
  final OffChainMediaInfoDto offChain;

  const MediaInfoDto({
    required this.onChain,
    required this.offChain,
  });

  factory MediaInfoDto.fromJson(Map<String, dynamic> json) {
    return MediaInfoDto(
      onChain: OnChainMediaInfoDto.fromJson(json['onchain']),
      offChain: OffChainMediaInfoDto.fromJson(json['offchain']),
    );
  }
}

final class OnChainMediaInfoDto {
  final String? tokenUri;

  const OnChainMediaInfoDto({
    this.tokenUri,
  });

  factory OnChainMediaInfoDto.fromJson(Map<String, dynamic> json) {
    return OnChainMediaInfoDto(
      tokenUri: json['token_uri'],
    );
  }
}

final class OffChainMediaInfoDto {
  final ImageInfoDto image;
  final AnimationInfoDto? animation;

  const OffChainMediaInfoDto({
    required this.image,
    this.animation,
  });

  factory OffChainMediaInfoDto.fromJson(Map<String, dynamic> json) {
    return OffChainMediaInfoDto(
      image: ImageInfoDto.fromJson(
        json['image'],
      ),
      animation: json['animation'] != null
          ? AnimationInfoDto.fromJson(
              json['animation'],
            )
          : null,
    );
  }
}

final class ImageInfoDto {
  final String? url;
  final String? contentType;

  const ImageInfoDto({
    this.url,
    this.contentType,
  });

  factory ImageInfoDto.fromJson(Map<String, dynamic> json) {
    return ImageInfoDto(
      url: json['url'],
      contentType: json['content_type'],
    );
  }
}

final class AnimationInfoDto {
  final String? url;
  final String? contentType;

  const AnimationInfoDto({
    this.url,
    this.contentType,
  });

  factory AnimationInfoDto.fromJson(Map<String, dynamic> json) {
    return AnimationInfoDto(
      url: json['url'],
      contentType: json['content_type'],
    );
  }
}

final class CW721ContractDto {
  final String name;
  final String symbol;
  final SmartContractDto smartContract;

  const CW721ContractDto({
    required this.name,
    required this.symbol,
    required this.smartContract,
  });

  factory CW721ContractDto.fromJson(Map<String, dynamic> json) {
    return CW721ContractDto(
      name: json['name'],
      symbol: json['symbol'],
      smartContract: SmartContractDto.fromJson(json['smart_contract']),
    );
  }
}

final class SmartContractDto {
  final String name;
  final String address;

  const SmartContractDto({
    required this.name,
    required this.address,
  });

  factory SmartContractDto.fromJson(Map<String, dynamic> json) {
    return SmartContractDto(
      name: json['name'],
      address: json['address'],
    );
  }
}
