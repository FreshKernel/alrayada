import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart' show VoidCallback;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/server.dart';

class DioService {
  DioService._();

  static final instance = DioService._();

  Dio? _dio;
  Dio get dio {
    _dio ??= _createDio();
    return _dio ?? (throw 'You forgot to create instance for dio');
  }

  Dio _createDio() {
    final dio = Dio();
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
      ));
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final baseUrl = await ServerConfigurations.getBaseUrl();
          if (options.uri.host == Uri.parse(baseUrl).host &&
              _accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final baseUrl = await ServerConfigurations.getBaseUrl();
          if (error.requestOptions.uri.host == Uri.parse(baseUrl).host &&
              _accessToken != null &&
              error.response?.statusCode == 401) {
            onInvalidToken?.call();
          }
          handler.next(error);
        },
      ),
    );
    return dio;
  }

  String? _accessToken;
  // ignore: unused_field
  String? _refreshToken;
  VoidCallback? onInvalidToken;

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
    onInvalidToken = null;
  }

  void setToken({
    required String accessToken,
    required String refreshToken,
    required VoidCallback onInvalidToken,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    this.onInvalidToken = onInvalidToken;
  }
}
