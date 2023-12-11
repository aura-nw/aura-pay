import 'package:aura_smart_account/src/core/aura_smart_account_cache.dart';

extension AuraAmount on String{
  String get toAura{
    String auraString = this;
    if(auraString.contains(AuraSmartAccountCache.deNom)){
      auraString = auraString.replaceAll(AuraSmartAccountCache.deNom, '');
    }

    double aura = double.tryParse(this) ?? 0;

    return (aura/1000000).toStringAsFixed(6);
  }

  String get toDenom{
    double aura = double.tryParse(this) ?? 0;

    return (aura * 1000000).round().toString();
  }
}