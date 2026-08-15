import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/errors/api_error_extractor.dart';
import '../../../../core/errors/exceptions.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/AuthController.cs
/// (api/v1/auth/register). Cree l'identite Keycloak + le Customer associe ;
/// l'app se connecte ensuite normalement via KeycloakService.login().
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String password,
    String? email,
  }) async {
    try {
      await _apiClient.post(
        '/auth/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
          'password': password,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        extractApiErrorMessage(e, fallback: 'Inscription impossible, veuillez reessayer'),
      );
    }
  }

  Future<void> resetPassword({
    required String phoneNumber,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        '/auth/reset-password',
        data: {
          'phoneNumber': phoneNumber,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        extractApiErrorMessage(e, fallback: 'Reinitialisation impossible, veuillez reessayer'),
      );
    }
  }
}
