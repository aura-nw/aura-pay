import 'package:domain/domain.dart';

extension TokenMarketDtoMapper on TokenMarketDto {
  TokenMarket get toEntity => TokenMarket(
        id: id,
        coinId: coinId,
        symbol: symbol,
        name: name,
        image: image,
        currentPrice: currentPrice,
        priceChangePercentage24h: priceChangePercentage24h,
        totalVolume: totalVolume,
        marketCap: marketCap,
        denom: denom,
        chainId: chainId,
      );
}

final class TokenMarketDto {
  final int id;
  final String coinId;
  final String symbol;
  final String name;
  final String image;
  final String currentPrice;
  final double priceChangePercentage24h;
  final String totalVolume;
  final String marketCap;
  final String denom;
  final String chainId;

  TokenMarketDto({
    required this.id,
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.totalVolume,
    required this.marketCap,
    required this.denom,
    required this.chainId,
  });

  factory TokenMarketDto.fromJson(Map<String, dynamic> json) {
    return TokenMarketDto(
      id: json['id'],
      coinId: json['coin_id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      currentPrice: json['current_price'],
      priceChangePercentage24h: json['price_change_percentage_24h'].toDouble(),
      totalVolume: json['total_volume'],
      marketCap: json['market_cap'],
      denom: json['denom'],
      chainId: json['chain_id'] ?? "",
    );
  }
}
