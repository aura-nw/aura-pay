extension AuraBalaceFormatter on String {
  String get formatAura {
    double auraD = double.tryParse(this) ?? 0;

    String auraString = (auraD / 1000000).toStringAsFixed(6);

    auraString = auraString.replaceAll(RegExp(r'0*$'), '');

    if (auraString.endsWith('.')) {
      auraString = auraString.substring(0, auraString.length - 1);
    }

    return auraString;
  }

  String formatTotalPrice(double price) {
    double auraD = double.tryParse(this) ?? 0;

    auraD = (auraD / 1000000);

    if (price == 0) return '0';

    auraD = auraD * price;

    String auraString = auraD.toStringAsFixed(2);

    auraString = auraString.replaceAll(RegExp(r'0*$'), '');

    if (auraString.endsWith('.')) {
      auraString = auraString.substring(0, auraString.length - 1);
    }

    return auraString;
  }

  String get toDenom {
    double aura = double.tryParse(this) ?? 0;

    return (aura * 1000000).round().toString();
  }
}

extension AuraNumberFormatter on num {
  String get formatAuraNumber {
    String auraString = toStringAsFixed(6);

    auraString = auraString.replaceAll(RegExp(r'0*$'), '');

    if (auraString.endsWith('.')) {
      auraString = auraString.substring(0, auraString.length - 1);
    }

    return auraString;
  }

  String get formatPrice {

    if (this == 0) return '0';

    String auraString = toStringAsFixed(2);

    auraString = auraString.replaceAll(RegExp(r'0*$'), '');

    if (auraString.endsWith('.')) {
      auraString = auraString.substring(0, auraString.length - 1);
    }

    return auraString;
  }
}
