import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';
import 'keycloak_service.dart';

/// Client HTTP unique de l'app. Toute feature MUST passer par ce client
/// (jamais d'appel HTTP direct depuis un Widget) -- cf. constitution TailorShop,
/// Principe VI.
class ApiClient {
  final Dio _dio;
  final KeycloakService _keycloakService;

  ApiClient(this._keycloakService)
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.apiBaseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
          ),
        ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _keycloakService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: const UnauthorizedException(),
              ),
            );
            return;
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams}) {
    return _dio.get<T>(path, queryParameters: queryParams);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) {
    return _dio.delete<T>(path);
  }
}
