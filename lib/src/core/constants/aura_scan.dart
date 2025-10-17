

import 'package:aurapay/app_configs/aura_pay_config.dart';

sealed class AuraScan{
 static String _domain = _domainSerenity;
 static void init(AuraPayEnvironment environment){
  switch(environment){
   case AuraPayEnvironment.serenity:
    _domain = _domainSerenity;
    break;
   case AuraPayEnvironment.staging:
    _domain = _domainEuphoria;
    break;
   case AuraPayEnvironment.production:
    _domain = _domainProduction;
    break;
  }
 }

 static const String _domainSerenity = 'https://serenity.aurascan.io/';
 static const String _domainEuphoria = 'https://euphoria.aurascan.io/';
 static const String _domainProduction = 'https://aurascan.io/';

 static String account(String address) => '${_domain}account/$address';
 static String transaction(String hash) => '${_domain}tx/$hash';
}