enum TransactionType {
  send,
  receive,
  callContract,
  stake,
  swap,
}

enum TransactionStatus {
  pending,
  success,
  failed,
}

class TransactionHistoryModel {
  final String id;
  final TransactionType type;
  final TransactionStatus status;
  final String address;
  final String? amount;
  final String? token;
  final DateTime timestamp;
  final String? hash;

  const TransactionHistoryModel({
    required this.id,
    required this.type,
    required this.status,
    required this.address,
    this.amount,
    this.token,
    required this.timestamp,
    this.hash,
  });

  // For display with localization
  String getTypeDisplayName(String Function(String) translate) {
    switch (type) {
      case TransactionType.send:
        return translate('transaction_type_send');
      case TransactionType.receive:
        return translate('transaction_type_receive');
      case TransactionType.callContract:
        return translate('transaction_type_call_contract');
      case TransactionType.stake:
        return translate('transaction_type_stake');
      case TransactionType.swap:
        return translate('transaction_type_swap');
    }
  }

  String getStatusDisplayName(String Function(String) translate) {
    switch (status) {
      case TransactionStatus.pending:
        return translate('transaction_status_pending');
      case TransactionStatus.success:
        return translate('transaction_status_success');
      case TransactionStatus.failed:
        return translate('transaction_status_failed');
    }
  }

  // For internal search purposes (English only)
  String get typeDisplayName {
    switch (type) {
      case TransactionType.send:
        return 'Send';
      case TransactionType.receive:
        return 'Receive';
      case TransactionType.callContract:
        return 'Call contract';
      case TransactionType.stake:
        return 'Stake';
      case TransactionType.swap:
        return 'Swap';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.success:
        return 'Success';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  String get displayAmount {
    if (amount == null || token == null) {
      return _formatAddress(address);
    }

    final prefix = type == TransactionType.receive ? '+' : '-';
    return '$prefix$amount $token';
  }

  String _formatAddress(String address) {
    if (address.length <= 13) return address;
    return '${address.substring(0, 9)}...${address.substring(address.length - 5)}';
  }
}

