import 'package:equatable/equatable.dart';

/// Miroir de l'entite backend `Customer`
/// (ApiTailorManagement/.../Domain/Customers/Customer.cs).
class Customer extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? gender;
  final String? address;
  final String city;

  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.gender,
    this.address,
    required this.city,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        phoneNumber: json['phoneNumber'] as String,
        gender: json['gender'] as String?,
        address: json['address'] as String?,
        city: json['city'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'address': address,
        'city': city,
      };

  @override
  List<Object?> get props => [id, firstName, lastName, phoneNumber, gender, address, city];
}
