import 'package:equatable/equatable.dart';

/// Miroir de l'entite backend `City` (Domain/Cities/City.cs).
/// Lecture seule cote mobile -- le backend n'expose pas de POST/PUT/DELETE
/// pour City (uniquement `POST /cities/import` en CSV, cote back-office).
class City extends Equatable {
  final String id;
  final String code;
  final String name;
  final bool isActive;

  const City({
    required this.id,
    required this.code,
    required this.name,
    required this.isActive,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        isActive: json['isActive'] as bool,
      );

  @override
  List<Object?> get props => [id, code, name, isActive];
}
