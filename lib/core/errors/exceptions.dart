/// Exception applicative avec un message destine a etre affiche tel quel a
/// l'utilisateur (voir [ErrorHandler] dans error_handler.dart, qui centralise
/// la conversion des erreurs reseau/HTTP vers ces types).
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = 'Erreur serveur, veuillez reessayer plus tard']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Pas de connexion internet']);
}

// Nommee "RequestTimeoutException" (pas "TimeoutException") pour ne pas
// entrer en conflit avec dart:async TimeoutException, levee nativement par
// Future.timeout() (utilise notamment dans KeycloakService).
class RequestTimeoutException extends AppException {
  const RequestTimeoutException([super.message = 'Connexion trop lente, veuillez reessayer']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Numero ou mot de passe incorrect']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Introuvable']);
}

class AccountAlreadyExistsException extends AppException {
  const AccountAlreadyExistsException([super.message = 'Ce numero est deja utilise']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Erreur de cache local']);
}
