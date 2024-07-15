final class PutAllTokenMarketRequest {
  final int id;
  final String coinId;
  final String symbol;
  final String name;
  final String image;
  final String currentPrice;
  final double priceChangePercentage24h;
  final String denom;
  final int decimal;

  const PutAllTokenMarketRequest({
    required this.id,
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.denom,
    required this.decimal,
  });
}