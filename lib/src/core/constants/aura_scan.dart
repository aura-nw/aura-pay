sealed class AuraScan{
 static const String _domainDev = 'https://explorer.dev.aura.network/';
 static const String _domainSerenity = 'https://serenity.aura.network/';
 static const String _domainEuphoria = 'https://euphoria.aura.network/';
 static const String _domainProduction = 'https://aura.network/';

 static String account(String address) => '${_domainDev}account/$address';
 static String transaction(String hash) => '${_domainDev}transaction/$hash';
}