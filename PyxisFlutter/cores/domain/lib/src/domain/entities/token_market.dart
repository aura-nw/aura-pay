final class TokenMarket {
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

  const TokenMarket({
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
}
