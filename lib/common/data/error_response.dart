import 'package:meta/meta.dart';

/// The same class as the one used in the server
@immutable
class ErrorResponse {
  const ErrorResponse({
    required this.message,
    required this.code,
    required this.data,
  });

  factory ErrorResponse.fromJson(Map<String, Object?> json) => ErrorResponse(
        message: json['message'] as String,
        code: json['code'] as String,
        data: json['data'] as Map<String, Object?>?,
      );

  final String message;
  final String code;
  final Map<String, Object?>? data;
}
