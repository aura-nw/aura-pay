import 'package:data/data.dart';
import 'package:isar/isar.dart';

part 'token_market_db.g.dart';

extension TokenMarketDtoRequestMapper on PutAllTokenMarketRequestDto {
  TokenMarketDb get mapRequestToDb => TokenMarketDb(
        tId: id,
        tCoinId: coinId,
        tSymbol: symbol,
        tName: name,
        tImage: image,
        tCurrentPrice: currentPrice,
        tPriceChangePercentage24h: priceChangePercentage24h,
        tDenom: denom,
        tDecimal: decimal,
      );
}

@Collection(inheritance: false)
final class TokenMarketDb extends TokenMarketDto {
  final Id tId;
  final String ?tCoinId;
  final String tSymbol;
  final String ?tName;
  final String ?tImage;
  final String tCurrentPrice;
  final double tPriceChangePercentage24h;
  final String ?tDenom;
  final int ?tDecimal;

  const TokenMarketDb({
    required this.tId,
    this.tCoinId,
    required this.tSymbol,
    this.tName,
    this.tImage,
    required this.tCurrentPrice,
    required this.tPriceChangePercentage24h,
    this.tDenom,
    this.tDecimal,
  }) : super(
          id: tId,
          name: tName,
          coinId: tCoinId,
          currentPrice: tCurrentPrice,
          decimal: tDecimal,
          denom: tDenom,
          image: tImage,
          priceChangePercentage24h: tPriceChangePercentage24h,
          symbol: tSymbol,
        );
}
