final class NFTsInformation {
  final List<NFTInformation> cw721Tokens;
  final int count;

  const NFTsInformation({
    required this.cw721Tokens,
    required this.count,
  });
}

final class NFTInformation {
  final int id;
  final String tokenId;
  final MediaInfo mediaInfo;
  final int lastUpdatedHeight;
  final DateTime createdAt;
  final CW721Contract cw721Contract;

  const NFTInformation({
    required this.id,
    required this.tokenId,
    required this.mediaInfo,
    required this.lastUpdatedHeight,
    required this.createdAt,
    required this.cw721Contract,
  });
}

final class MediaInfo {
  final OnChainMediaInfo onChain;
  final OffChainMediaInfo offChain;

  const MediaInfo({
    required this.onChain,
    required this.offChain,
  });
}

final class OnChainMediaInfo {
  final String? tokenUri;

  const OnChainMediaInfo({
    required this.tokenUri,
  });
}

final class OffChainMediaInfo {
  final ImageInfo image;
  final AnimationInfo ?animation;

  const OffChainMediaInfo({
    required this.image,
    this.animation,
  });
}

final class ImageInfo {
  final String? url;
  final String? contentType;

  const ImageInfo({
    this.url,
    this.contentType,
  });
}

final class AnimationInfo{
  final String? url;
  final String? contentType;

  const AnimationInfo({this.url,this.contentType});
}

final class CW721Contract {
  final String name;
  final String symbol;
  final SmartContract smartContract;

  const CW721Contract({
    required this.name,
    required this.symbol,
    required this.smartContract,
  });
}

final class SmartContract {
  final String name;
  final String address;

  const SmartContract({
    required this.name,
    required this.address,
  });
}
