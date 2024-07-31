import 'package:domain/domain.dart';
import 'package:pyxis_v2/src/core/constants/asset_path.dart';
import 'package:wallet_core/wallet_core.dart';

extension AppNetworkExtension on AppNetwork {
  String get logo {
    String logo = AssetIconPath.icCommonAuraCosmos;
    switch (type) {
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

  int get coinType {
    // Change later
    switch (type) {
      case AppNetworkType.cosmos:
        return TWCoinType.TWCoinTypeCosmos;
      case AppNetworkType.evm:
        return TWCoinType.TWCoinTypeEthereum;
      case AppNetworkType.other:
        return TWCoinType.TWCoinTypeEthereum;
    }
  }

  String getAddress(Account account) {
    switch (type) {
      case AppNetworkType.cosmos:
        return account.aCosmosInfo.displayAddress;
      case AppNetworkType.evm:
        return account.aEvmInfo.displayAddress;
      case AppNetworkType.other:
        return '';
    }
  }

  List<Balance> tokenWithType(List<Balance> tokens) {
    switch (type) {
      case AppNetworkType.cosmos:
        // return tokens
        //     .where(
        //       (e) => e.type == TokenType.cw20 || e.type == TokenType.native,
        //     )
        //     .toList();
        return [];
      case AppNetworkType.evm:
        // return tokens
        //     .where(
        //       (e) => e.type == TokenType.erc20 || e.type == TokenType.native,
        //     )
        //     .toList();
        return [];
      case AppNetworkType.other:
        return [];
    }
  }
}

extension AppNetworkTypeExtension on AppNetworkType{
  String getAuraCosmosAddressByCreateType(String address){
    switch (this) {
      case AppNetworkType.cosmos:
        final data = bech32.makeBech32Decoder('cosmos', address);
        return bech32.makeBech32Encoder('aura', data);
      case AppNetworkType.evm:
        return bech32.convertEthAddressToBech32Address('aura', address);
      case AppNetworkType.other:
        return bech32.convertEthAddressToBech32Address('aura', address);
    }
  }

  String getAuraEvmAddressByCreateType(String address){
    switch (this) {
      case AppNetworkType.cosmos:
        return bech32.convertBech32AddressToEthAddress('cosmos', address);
      case AppNetworkType.evm:
        return address;
      case AppNetworkType.other:
        return address;
    }
  }
}