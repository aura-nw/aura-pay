library wallet_services;

import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:wallet_services/src/managements/stored_key_management.dart';
import 'package:wallet_services/src/managements/wallet_management.dart';

// Exporting necessary packages for external usage
export 'package:trust_wallet_core/trust_wallet_core_ffi.dart';
export 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
export 'package:trust_wallet_core/trust_wallet_core.dart';
export 'package:wallet_services/src/managements/stored_key_management.dart';
export 'package:wallet_services/src/managements/wallet_management.dart';
export 'package:wallet_services/src/objects/a_wallet.dart';
export 'package:wallet_services/src/objects/chain_info.dart';
export 'package:wallet_services/src/constants/chain_list.dart';
export 'package:wallet_services/src/chains/evm.dart';
export 'package:wallet_services/src/utils/address_converter.dart';
export 'package:wallet_services/src/utils/message_creator.dart';
export 'package:wallet_services/src/utils/wallet_utils.dart';
export 'package:web3dart/crypto.dart';

/// WalletServices class provides various functionalities to manage wallets.
class WalletServices {
  static void init() {
    FlutterTrustWalletCore.init();
  }

  static WalletManagement walletManagement = WalletManagement();
  static StoredManagement storedManagement = StoredManagement();
}
