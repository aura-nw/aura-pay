import 'package:pyxis_mobile/app_configs/pyxis_mobile_config.dart';

sealed class AuraScan{
 static String _domain = _domainDev;
 static void init(PyxisEnvironment pyxisEnvironment){
  switch(pyxisEnvironment){
   case PyxisEnvironment.dev:
    _domain = _domainDev;
    break;
   case PyxisEnvironment.serenity:
    _domain = _domainSerenity;
    break;
   case PyxisEnvironment.staging:
    _domain = _domainEuphoria;
    break;
   case PyxisEnvironment.production:
    _domain = _domainProduction;
    break;
  }
 }

 static const String _domainDev = 'https://explorer.dev.aura.network/';
 static const String _domainSerenity = 'https://serenity.aura.network/';
 static const String _domainEuphoria = 'https://euphoria.aura.network/';
 static const String _domainProduction = 'https://aura.network/';

 static String account(String address) => '${_domain}account/$address';
 static String transaction(String hash) => '${_domain}transaction/$hash';
}