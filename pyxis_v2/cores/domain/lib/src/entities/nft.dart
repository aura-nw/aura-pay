class EvmNFT {
  final int chainId;
  final String contract;
  final String tokenId;
  final String kind;
  final String name;
  final String image;
  final Metadata metadata;
  final String description;
  final bool metadataDisabled;
  final EvmCollection collection;
  final FloorAsk floorAsk;

  const EvmNFT({
    required this.chainId,
    required this.contract,
    required this.tokenId,
    required this.kind,
    required this.name,
    required this.image,
    required this.metadata,
    required this.description,
    required this.metadataDisabled,
    required this.collection,
    required this.floorAsk,
  });

  // factory Token.fromJson(Map<String, dynamic> json) {
  //   return Token(
  //     chainId: json['chainId'],
  //     contract: json['contract'],
  //     tokenId: json['tokenId'],
  //     kind: json['kind'],
  //     name: json['name'],
  //     image: json['image'],
  //     imageSmall: json['imageSmall'],
  //     imageLarge: json['imageLarge'],
  //     metadata: Metadata.fromJson(json['metadata']),
  //     description: json['description'],
  //     metadataDisabled: json['metadataDisabled'],
  //     lastFlagUpdate: DateTime.parse(json['lastFlagUpdate']),
  //     lastFlagChange: DateTime.parse(json['lastFlagChange']),
  //     collection: Collection.fromJson(json['collection']),
  //     floorAsk: FloorAsk.fromJson(json['floorAsk']),
  //   );
  // }
}

class Metadata {
  final String imageOriginal;
  final String imageMimeType;
  final String tokenURI;

  const Metadata({
    required this.imageOriginal,
    required this.imageMimeType,
    required this.tokenURI,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      imageOriginal: json['imageOriginal'],
      imageMimeType: json['imageMimeType'],
      tokenURI: json['tokenURI'],
    );
  }
}

class EvmCollection {
  final String id;
  final String name;
  final String imageUrl;
  final bool isSpam;
  final bool isNsfw;
  final bool metadataDisabled;
  final int tokenCount;
  final FloorAsk? floorAsk;

  const EvmCollection({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.isSpam,
    required this.isNsfw,
    required this.metadataDisabled,
    required this.tokenCount,
    this.floorAsk,
  });

  // factory EvmCollection.fromJson(Map<String, dynamic> json) {
  //   return EvmCollection(
  //     id: json['id'],
  //     name: json['name'],
  //     slug: json['slug'],
  //     symbol: json['symbol'],
  //     contractDeployedAt: DateTime.parse(json['contractDeployedAt']),
  //     imageUrl: json['imageUrl'],
  //     isSpam: json['isSpam'],
  //     isNsfw: json['isNsfw'],
  //     metadataDisabled: json['metadataDisabled'],
  //     tokenCount: json['tokenCount'],
  //     floorAsk:
  //         json['floorAsk'] != null ? FloorAsk.fromJson(json['floorAsk']) : null,
  //     royaltiesBps: json['royaltiesBps'],
  //     royalties: json['royalties'],
  //   );
  // }
}

class FloorAsk {
  final String id;
  final Price price;
  final String maker;
  final int validFrom;
  final int validUntil;
  final dynamic source;

  const FloorAsk({
    required this.id,
    required this.price,
    required this.maker,
    required this.validFrom,
    required this.validUntil,
    this.source,
  });

  factory FloorAsk.fromJson(Map<String, dynamic> json) {
    return FloorAsk(
      id: json['id'],
      price: Price.fromJson(json['price']),
      maker: json['maker'],
      validFrom: json['validFrom'],
      validUntil: json['validUntil'],
      source: json['source'],
    );
  }
}

class Price {
  final Currency currency;
  final Amount amount;

  const Price({
    required this.currency,
    required this.amount,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      currency: Currency.fromJson(json['currency']),
      amount: Amount.fromJson(json['amount']),
    );
  }
}

class Currency {
  final String contract;

  const Currency({
    required this.contract,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      contract: json['contract'],
    );
  }
}

class Amount {
  final String raw;
  final int decimal;
  final dynamic usd;
  final int native;

  const Amount({
    required this.raw,
    required this.decimal,
    this.usd,
    required this.native,
  });

  factory Amount.fromJson(Map<String, dynamic> json) {
    return Amount(
      raw: json['raw'],
      decimal: json['decimal'],
      usd: json['usd'],
      native: json['native'],
    );
  }
}
