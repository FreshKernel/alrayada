import 'package:dio/dio.dart';

extension DioResponseExtensions<T> on Response<T> {
  T get dataOrThrow {
    final responseData = data;
    if (responseData == null) {
      throw StateError('The response data can not be null');
    }
    return responseData;
  }
}
