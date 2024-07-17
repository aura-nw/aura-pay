import 'package:domain/domain.dart';

String _replaceDot(String value){
  value = value.replaceAll(RegExp(r'0*$'), '');

  if (value.endsWith('.')) {
    value = value.substring(0, value.length - 1);
  }

  return value;
}

extension FormatAuraByType on TokenType{
  String formatBalance(String balance,{int ?customDecimal}){
    int decimal = 1000000000000000000;
    switch(this){
      case TokenType.native:
        break;
      case TokenType.erc20:
        decimal = customDecimal ?? decimal;
        break;
      case TokenType.cw20:
        decimal = customDecimal ?? decimal;
        break;
    }

    double auraD = double.tryParse(balance) ?? 0;

    String auraString = (auraD / decimal).toStringAsFixed(6);

    return _replaceDot(auraString);
  }
}

extension AuraNumberFormatter on num {

  bool get  isIncrease => this > 0;

  String get prefixValueChange{
    if(isIncrease){
      return '+';
    }
    return '';
  }


  String get formatPercent{
    String percent = toStringAsFixed(2);

    return _replaceDot(percent);
  }

  String get formatPrice {
    if (this == 0) return '0';

    String price = toStringAsFixed(2);

    return _replaceDot(price);
  }

  String get formatPnl24 {
    if (this == 0) return '0';

    String price = toStringAsFixed(4);

    return _replaceDot(price);
  }
}
