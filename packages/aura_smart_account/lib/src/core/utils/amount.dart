extension AuraAmount on String{
  String get toAura{
    double aura = double.tryParse(this) ?? 0;

    return (aura/1000000).toStringAsFixed(2);
  }
}