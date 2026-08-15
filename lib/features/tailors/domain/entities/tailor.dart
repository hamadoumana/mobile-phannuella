import 'package:equatable/equatable.dart';

/// Miroir de l'entite backend `Tailor`
/// (ApiTailorManagement/.../Domain/Tailors/Tailor.cs).
class Tailor extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String city;
  final String workshopAddress;
  final String? specialties;
  final String? photoUrl;

  const Tailor({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.city,
    required this.workshopAddress,
    this.specialties,
    this.photoUrl,
  });

  factory Tailor.fromJson(Map<String, dynamic> json) => Tailor(
        id: json['id'] as String,
        name: json['name'] as String,
        phoneNumber: json['phoneNumber'] as String,
        city: json['city'] as String,
        workshopAddress: json['workshopAddress'] as String,
        specialties: json['specialties'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'city': city,
        'workshopAddress': workshopAddress,
        'specialties': specialties,
        'photoUrl': photoUrl,
      };

  @override
  List<Object?> get props =>
      [id, name, phoneNumber, city, workshopAddress, specialties, photoUrl];
}
