import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  // 10.0.2.2 = alias emulateur Android vers le localhost de la machine hote
  // (backend ApiTailorManagement lance en local via `dotnet run`, port 5001).
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:5001/api/v1';

  static String get keycloakBaseUrl =>
      dotenv.env['KEYCLOAK_BASE_URL'] ?? 'https://auth.tailorshop.local';

  static String get keycloakRealm => dotenv.env['KEYCLOAK_REALM'] ?? 'tailorshop';

  static String get keycloakClientId =>
      dotenv.env['KEYCLOAK_CLIENT_ID'] ?? 'tailorshop-mobile';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Le backend renvoie parfois des URLs media (photoUrl, clothingModelPhotoUrl)
  /// codees en dur sur `localhost` cote serveur (Minio, port 9000 -- different
  /// du port de l'API). Depuis l'emulateur Android, `localhost` pointe vers
  /// l'emulateur lui-meme -- on reecrit uniquement l'hote avec celui
  /// reellement utilise pour joindre la machine hote (ex: 10.0.2.2), en
  /// conservant le port d'origine (celui de Minio, pas celui de l'API).
  static String resolveMediaUrl(String url) {
    final mediaUri = Uri.tryParse(url);
    if (mediaUri == null) return url;
    if (mediaUri.host != 'localhost' && mediaUri.host != '127.0.0.1') return url;

    final apiUri = Uri.parse(apiBaseUrl);
    return mediaUri.replace(host: apiUri.host).toString();
  }
}
