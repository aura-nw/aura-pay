sealed class AuraSmartAccountCache{
  static late String deNom;
  static late String chainId;

  static void init(String deNom, String chainId,){
    AuraSmartAccountCache.deNom = deNom;
    AuraSmartAccountCache.chainId = chainId;
  }
}