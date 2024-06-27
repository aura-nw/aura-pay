import 'package:pyxis_mobile/src/core/constants/enum_type.dart';
import 'package:pyxis_mobile/src/core/helpers/wallet_address_validator.dart';

final class ScanResult {
  final String raw;
  final ScanResultType type;

  const ScanResult({
    required this.raw,
    this.type = ScanResultType.other,
  });

  ScanResult copyWith({
    String? raw,
    ScanResultType? type,
  }) {
    return ScanResult(
      raw: raw ?? this.raw,
      type: type ?? this.type,
    );
  }
}

sealed class ScanValidator {
  static const String wcPrefix = 'wc:';

  static ScanResult validateResult(String raw) {
    ScanResult result = ScanResult(
      raw: raw,
    );
    if (raw.startsWith(wcPrefix)) {
      result = result.copyWith(
        type: ScanResultType.walletConnect,
      );
    } else if (WalletAddressValidator.isValidAddress(raw)) {
      result = result.copyWith(
        type: ScanResultType.walletAddress,
      );
    }

    return result;
  }
}
