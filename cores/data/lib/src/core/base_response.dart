import 'package:domain/domain.dart';

abstract class BaseResponse<T> {
  final T? data;

  const BaseResponse({this.data});
}

final class BaseResponseV2<T> extends BaseResponse<T> {
  final int code;
  final String message;

  const BaseResponseV2({
    required this.code,
    super.data,
    required this.message,
  });

  factory BaseResponseV2.fromJson(Map<String, dynamic> json) {
    return BaseResponseV2(
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
      code: code,
    );
  }
}

final class BaseResponseV1<T> extends BaseResponse<T> {
  const BaseResponseV1({
    super.data,
  });

  factory BaseResponseV1.fromJson(Map<String, dynamic> json) {
    return BaseResponseV1(
      data: json['data'],
    );
  }
}

final class PyxisBaseResponse extends BaseResponse<Map<String,dynamic>> {
  const PyxisBaseResponse({
    super.data,
  });

  factory PyxisBaseResponse.fromJson(Map<String, dynamic> json) {
    return PyxisBaseResponse(
      data: json,
    );
  }
}
