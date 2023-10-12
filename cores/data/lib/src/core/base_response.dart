import 'package:domain/domain.dart';

class BaseResponse<T> {
  final int code;
  final T? data;
  final String message;

  const BaseResponse({
    required this.code,
    this.data,
    required this.message,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }

  static T? handleResponse<T>(BaseResponse<T> response) {
    if (response.code == 200) {
      return response.data;
    }

    throw AppError(
      message: response.message,
      code: response.code,
    );
  }
}
