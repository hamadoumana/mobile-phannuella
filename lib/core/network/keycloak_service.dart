import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

/// Authentification Keycloak (Resource Owner Password Grant).
///
/// Firebase Auth n'est pas utilise dans ce projet -- cf. constitution TailorShop,
/// Principe VI (Frontend & Mobile Standards).
class KeycloakService {
  static const _accessTokenKey = 'kc_access_token';
  static const _refreshTokenKey = 'kc_refresh_token';
  static const _guestModeKey = 'kc_guest_mode';

  /// `http.Client` n'a pas de timeout par defaut (contrairement au Dio de
  /// l'ApiClient) : sans ceci, un realm Keycloak injoignable (DNS/refuse)
  /// peut bloquer indefiniment la redirection initiale de go_router.
  static const _networkTimeout = Duration(seconds: 8);

  final FlutterSecureStorage _storage;
  final http.Client _httpClient;

  KeycloakService({FlutterSecureStorage? storage, http.Client? httpClient,})  : _storage = storage ?? const FlutterSecureStorage(),
        _httpClient = httpClient ?? http.Client();

  Uri get _tokenEndpoint => Uri.parse(
        '${ApiConstants.keycloakBaseUrl}/realms/${ApiConstants.keycloakRealm}'
        '/protocol/openid-connect/token',
      );

  Uri get _logoutEndpoint => Uri.parse(
        '${ApiConstants.keycloakBaseUrl}/realms/${ApiConstants.keycloakRealm}'
        '/protocol/openid-connect/logout',
      );

  Future<void> login({required String username, required String password}) async {
    final response = await _httpClient.post(
      _tokenEndpoint,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'password',
        'client_id': ApiConstants.keycloakClientId,
        'username': username,
        'password': password,
      },
    ).timeout(_networkTimeout);

    if (response.statusCode != 200) {
      throw const UnauthorizedException('Identifiants invalides');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    await _storage.write(key: _accessTokenKey, value: data['access_token'] as String);
    await _storage.write(key: _refreshTokenKey, value: data['refresh_token'] as String);
  }

  /// Mode invite : contourne Keycloak pour explorer l'app sans backend/realm
  /// configure. TODO(AUTH): a retirer avant la mise en production.
  Future<void> loginAsGuest() async {
    await _storage.write(key: _guestModeKey, value: 'true');
  }

  Future<bool> isGuest() async {
    return await _storage.read(key: _guestModeKey) == 'true';
  }

  Future<String?> getAccessToken() async {
    final token = await _storage.read(key: _accessTokenKey);
    if (token == null) return null;
    if (JwtDecoder.isExpired(token)) {
      try {
        return await _refreshAccessToken();
      } catch (_) {
        // Realm Keycloak injoignable (timeout/DNS) : on considere la
        // session expiree plutot que de bloquer l'appelant indefiniment.
        await _clearTokens();
        return null;
      }
    }
    return token;
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken == null) return null;

    final response = await _httpClient.post(
      _tokenEndpoint,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'refresh_token',
        'client_id': ApiConstants.keycloakClientId,
        'refresh_token': refreshToken,
      },
    ).timeout(_networkTimeout);

    if (response.statusCode != 200) {
      await _clearTokens();
      return null;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    await _storage.write(key: _accessTokenKey, value: data['access_token'] as String);
    await _storage.write(key: _refreshTokenKey, value: data['refresh_token'] as String);
    return data['access_token'] as String;
  }

  /// Claims du JWT Keycloak (preferred_username, email, name...).
  /// Retourne null en mode invite ou si aucun token n'est present.
  Future<Map<String, dynamic>?> getUserClaims() async {
    if (await isGuest()) return null;
    final token = await getAccessToken();
    if (token == null) return null;
    return JwtDecoder.decode(token);
  }

  /// Ne doit jamais lancer d'exception ni bloquer indefiniment : c'est
  /// appele depuis le `redirect` de go_router a chaque navigation.
  Future<bool> isLoggedIn() async {
    try {
      if (await isGuest()) return true;
      final token = await getAccessToken();
      return token != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken != null) {
      try {
        await _httpClient.post(
          _logoutEndpoint,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'client_id': ApiConstants.keycloakClientId,
            'refresh_token': refreshToken,
          },
        ).timeout(_networkTimeout);
      } catch (_) {
        // Realm injoignable : on nettoie quand meme la session locale.
      }
    }
    await _clearTokens();
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _guestModeKey);
  }
}
