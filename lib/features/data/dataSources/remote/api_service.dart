import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Auth error callback type definition
typedef AuthErrorCallback = void Function();

// Global auth error callback provider - singleton olarak callback'i tutar
final authErrorCallbackProvider = StateProvider<AuthErrorCallback?>(
  (ref) => null,
);

final apiServiceProvider = Provider.autoDispose<ApiService>((ref) {
  final callback = ref.watch(authErrorCallbackProvider);
  final service = ApiService();

  // Callback varsa set et
  if (callback != null) {
    service.setAuthErrorCallback(callback);
  }

  return service;
});

class ApiService {
  late Dio _dio;
  AuthErrorCallback? _onAuthError;

  ApiService() {
    _initializeDio();
  }

  /// Auth error callback'ini ayarla
  void setAuthErrorCallback(AuthErrorCallback callback) {
    _onAuthError = callback;
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  Dio get dio => _dio;

  /// Reset Dio instance - Sign out için
  /// Bu metod Dio instance'ını yeniden oluşturur ve tüm cache'leri temizler
  void reset() {
    _dio.close(force: true);
    _initializeDio();
    log('🔄 ApiService reset completed');
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        request: true,
        enabled: kDebugMode,
        filter: (options, args) {
          // don't print requests with uris containing '/posts'
          if (options.path.contains('/posts')) {
            return false;
          }

          // Tüm isteklerde base64 içeren request body'leri filtreleme
          if (options.data != null) {
            final data = options.data.toString();
            // Base64 benzeri uzun string'leri tespit et (>1000 karakter)
            if (data.length > 1000 ||
                data.contains('base64') ||
                data.contains('imageBase64') ||
                data.contains('documentBase64')) {
              // Request'i logla ama body'yi gösterme
              return false;
            }
          }

          // don't print responses with unit8 list data
          return !args.isResponse || !args.hasUint8ListData;
        },
      ),
    );

    // Auth error interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Hata mesajını kontrol et
          final responseData = error.response?.data;

          if (responseData != null && responseData is Map) {
            final message = responseData['Message'] ?? responseData['message'];

            // Auth token bulunamadı hatası kontrolü
            if (message != null &&
                message.toString().contains('Lütfen yeniden giriş yapınız')) {
              log(
                '🔐 Auth Token Error Detected! Redirecting to login...',
                name: 'ApiService',
              );

              // Auth error callback'i tetikle
              if (_onAuthError != null) {
                _onAuthError!();
              } else {
                log('⚠️ Auth error callback is null!', name: 'ApiService');
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<Response> get(
    String path,
    String authHeader, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: {'Auth': authHeader}),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // POST request
  Future<Response> post(
    String path,
    String authHeader, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: {'Auth': authHeader}),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    log('📤 POST REQUEST: ${response.requestOptions.path}');
    return response;
  }

  // PUT request
  Future<Response> put(
    String path,
    String authHeader, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: {'Auth': authHeader}),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path,
    String authHeader, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: {'Auth': authHeader}),
      cancelToken: cancelToken,
    );
  }

  // PATCH request
  Future<Response> patch(
    String path,
    String authHeader, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: {'Auth': authHeader}),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
