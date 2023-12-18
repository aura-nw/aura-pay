import 'package:domain/domain.dart';

extension PyxisTransactionDtoMapper on PyxisTransactionDto {
  PyxisTransaction get toEntity => PyxisTransaction(
        status: status,
        txHash: txHash,
        timeStamp: timeStamp,
        msg: msg,
        fee: fee,
        memo: memo,
      );

  PyxisTransactionDto copyWith({
    int? status,
    String? txHash,
    String? timeStamp,
    String? fee,
    Map<String,dynamic>? msg,
    String? memo,
  }) {
    return PyxisTransactionDto(
      status: status ?? this.status,
      txHash: txHash ?? this.txHash,
      timeStamp: timeStamp ?? this.timeStamp,
      fee: fee ?? this.fee,
      msg: msg ?? this.msg,
      memo: memo ?? this.memo,
    );
  }
}

final class PyxisTransactionDto {
  final String txHash;
  final int status;
  final String timeStamp;
  final String fee;
  final String? memo;
  final Map<String, dynamic> msg;

  const PyxisTransactionDto({
    required this.status,
    required this.txHash,
    required this.timeStamp,
    required this.fee,
    required this.msg,
    this.memo,
  });

  bool get isSuccess => status == 0;

  factory PyxisTransactionDto.fromJson(Map<String, dynamic> json) {
    return PyxisTransactionDto(
      status: json['code'],
      txHash: json['txhash'],
      timeStamp: json['timestamp'],
      fee: '',
      msg: {},
    );
  }
}
