import 'package:domain/domain.dart';
import 'package:aurapay/app_configs/pyxis_mobile_config.dart';

List<AppNetwork> createNetwork(PyxisMobileConfig config){
  return [
    AppNetwork(
      id: 1,
      type: AppNetworkType.evm,
      rpc: config.config.evmInfo.rpc,
      symbol: config.config.evmInfo.symbol,
      denom: config.config.evmInfo.denom,
      isActive: true,
      name: config.config.evmInfo.chainName,
    ),
    AppNetwork(
      id: 2,
      type: AppNetworkType.cosmos,
      rpc: config.config.cosmosInfo.rpc,
      symbol: config.config.cosmosInfo.symbol,
      denom: config.config.cosmosInfo.denom,
      isActive: true,
      name: config.config.cosmosInfo.chainName,
    ),
  ];
}