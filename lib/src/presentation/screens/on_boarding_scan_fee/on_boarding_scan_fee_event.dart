import 'package:freezed_annotation/freezed_annotation.dart';
part 'on_boarding_scan_fee_event.freezed.dart';

@freezed
class OnBoardingScanFeeEvent with _$OnBoardingScanFeeEvent{
  const factory OnBoardingScanFeeEvent.checkBalance() = OnBoardingScanFeeOnCheckingBalanceEvent;
  const factory OnBoardingScanFeeEvent.createBalance() = OnBoardingScanFeeOnActiveSmartAccountEvent;
}