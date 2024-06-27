import 'package:domain/domain.dart';

abstract class BaseResponse<T> {
  final T? data;

  const BaseResponse({this.data});
}

final class AuraBaseResponseV2<T> extends BaseResponse<T> {
  final int code;
  final String message;

  const AuraBaseResponseV2({
    required this.code,
    super.data,
    required this.message,
  });

  factory AuraBaseResponseV2.fromJson(Map<String, dynamic> json) {
    return AuraBaseResponseV2(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }

  T? handleResponse() {
    if (code == 200) {
      return data;
    }

    throw AppError(
      message: message,
      code: code.toString(),
    );
  }
}

final class AuraBaseResponseV1<T> extends BaseResponse<T> {
  const AuraBaseResponseV1({
    super.data,
  });

  factory AuraBaseResponseV1.fromJson(T json) {
    return AuraBaseResponseV1(
      data: json,
    );
  }
}

final class HasuraBaseResponse<T> extends BaseResponse<T> {
  const HasuraBaseResponse({
    super.data,
  });

  factory HasuraBaseResponse.fromJson(Map<String, dynamic> json) {
    return HasuraBaseResponse(
      data: json['data'],
    );
  }
}

final class PyxisBaseResponse<T> extends BaseResponse<T> {
  final String errorCode;
  final String message;

  const PyxisBaseResponse({
    required this.errorCode,
    required this.message,
    super.data,
  });

  factory PyxisBaseResponse.fromJson(Map<String, dynamic> json) {
    return PyxisBaseResponse(
      errorCode: json['ErrorCode']?.toString() ?? '',
      message: json['Message'] ?? '',
      data: json['Data'],
    );
  }

  T? handleResponse() {
    if (errorCode == 'SUCCESSFUL') {
      return data;
    }

    throw AppError(
      message: message,
      code: errorCode,
    );
  }
}
