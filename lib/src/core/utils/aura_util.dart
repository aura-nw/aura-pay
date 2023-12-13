extension AuraFormatter on String {
  String get formatAura {
    double auraD = double.tryParse(this) ?? 0;

    String auraString = (auraD/1000000).toStringAsFixed(6);

    auraString = auraString.replaceAll(RegExp(r'0*$'),'');

    if (auraString.endsWith('.')) {
      auraString = auraString.substring(0, auraString.length - 1);
    }

    return auraString;
  }

  String get toDenom{
    double aura = double.tryParse(this) ?? 0;

    return (aura * 1000000).round().toString();
  }
}
