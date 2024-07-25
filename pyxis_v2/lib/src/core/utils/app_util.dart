import 'package:domain/domain.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';

extension AppNetworkExtension on AppNetwork{
  String get logo {
    String logo = AssetIconPath.icCommonAuraCosmos;
    switch(type){
      case AppNetworkType.cosmos:
        break;
      case AppNetworkType.evm:
        logo = AssetIconPath.icCommonAuraEvm;
        break;
      case AppNetworkType.other:
        break;
    }

    return logo;
  }

  String getAddress(Account account){
    switch(type){
      case AppNetworkType.cosmos:
        return account.aCosmosInfo.address;
      case AppNetworkType.evm:
        return account.aEvmInfo.address;
      case AppNetworkType.other:
        return '';
    }
  }
}