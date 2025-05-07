import 'dart:io';

import 'base_api_exception.dart';


class CustomStatusCodeException extends BaseApiException {
  CustomStatusCodeException(int httpCode, String message, String status)
      : super(
            httpCode: httpCode,
            message: message,
            status: status);
}
