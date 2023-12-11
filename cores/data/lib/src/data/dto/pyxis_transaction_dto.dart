import 'package:domain/domain.dart';

extension PyxisTransactionDtoMapper on PyxisTransactionDto {
  PyxisTransaction get toEntity => PyxisTransaction(
        status: status,
        txHash: txHash,
        timeStamp: timeStamp,
        event: event.toEntity,
      );
}

extension PyxisTransactionEventDtoMapper on PyxisTransactionEventDto {
  PyxisTransactionEvent get toEntity => PyxisTransactionEvent(
        values: values
            .map(
              (e) => e.toEntity,
            )
            .toList(),
        type: type,
      );
}

extension PyxisTransactionAttributeDtoMapper on PyxisTransactionAttributeDto {
  PyxisTransactionAttribute get toEntity => PyxisTransactionAttribute(
        key: key,
        value: value,
      );
}

final class PyxisTransactionDto {
  final String txHash;
  final int status;
  final String timeStamp;
  final PyxisTransactionEventDto event;

  const PyxisTransactionDto({
    required this.status,
    required this.txHash,
    required this.timeStamp,
    required this.event,
  });

  bool get isSuccess => status == 0;
}

final class PyxisTransactionEventDto {
  final String type;
  final List<PyxisTransactionAttributeDto> values;

  const PyxisTransactionEventDto({
    required this.values,
    required this.type,
  });
}

final class PyxisTransactionAttributeDto {
  final String key;
  final String value;

  const PyxisTransactionAttributeDto({
    required this.key,
    required this.value,
  });
}
