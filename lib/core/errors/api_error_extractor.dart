import 'package:dio/dio.dart';

/// Extrait un message d'erreur lisible d'une reponse ProblemDetails du backend
/// (Hellang.Middleware.ProblemDetails). Les erreurs FluentValidation levees via
/// `throw new ValidationException(string)` (message unique) arrivent avec un
/// dictionnaire `errors` vide mais le texte dans `detail` -- voir le meme souci
/// deja rencontre sur /auth/reset-password.
String extractApiErrorMessage(DioException e, {required String fallback}) {
  final data = e.response?.data;
  if (data is Map<String, dynamic> && data['errors'] is Map) {
    final errors = (data['errors'] as Map).values.expand((v) => v as List).join('\n');
    if (errors.isNotEmpty) return errors;
  }
  if (data is Map<String, dynamic> && data['detail'] is String && (data['detail'] as String).isNotEmpty) {
    return data['detail'] as String;
  }
  if (data is Map<String, dynamic> && data['title'] is String) {
    return data['title'] as String;
  }
  return fallback;
}
