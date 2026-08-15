import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'api_error_extractor.dart';
import 'exceptions.dart';

/// Transforme n'importe quelle exception (reseau, HTTP, timeout, ou deja une
/// [AppException]) en [AppException] avec un message lisible, pour un
/// affichage uniforme cote UI (voir AuthBloc pour l'usage).
class ErrorHandler {
  static AppException handle(Object error) {
    // Deja une des notres (ex: KeycloakService jette UnauthorizedException
    // directement, ou un repository a deja mappe l'erreur) : on la garde
    // telle quelle plutot que de la reduire a un message generique.
    if (error is AppException) {
      return error;
    }

    // Future.timeout() (utilise par KeycloakService) leve dart:async
    // TimeoutException, pas la notre -- sinon message brut illisible
    // ("TimeoutException after 0:00:08.000000: ...") affiche a l'utilisateur.
    if (error is TimeoutException) {
      return const RequestTimeoutException();
    }

    if (error is SocketException) {
      return const NetworkException();
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const RequestTimeoutException();
        case DioExceptionType.connectionError:
          return const NetworkException();
        default:
          break;
      }

      final statusCode = error.response?.statusCode;
      if (statusCode == null) {
        return const NetworkException();
      }

      switch (statusCode) {
        case 401:
          return UnauthorizedException(
            extractApiErrorMessage(error, fallback: 'Numero de Téléphone ou mot de passe incorrect'),
          );
        case 404:
          return NotFoundException(
            extractApiErrorMessage(error, fallback: 'Introuvable'),
          );
        case 409:
          return AccountAlreadyExistsException(
            extractApiErrorMessage(error, fallback: 'Ce Numero de Téléphone est deja utilisé'),
          );
        default:
          if (statusCode >= 500) {
            return ServerException(
              extractApiErrorMessage(error, fallback: 'Erreur serveur, veuillez reessayer plus tard'),
            );
          }
          // 400 et autres 4xx non geres explicitement : erreurs de
          // validation, le backend renvoie le detail exact (ProblemDetails).
          return AppException(
            extractApiErrorMessage(error, fallback: 'Requete invalide'),
          );
      }
    }

    return const AppException('Une erreur est survenue');
  }
}
