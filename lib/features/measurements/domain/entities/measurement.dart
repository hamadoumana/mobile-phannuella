import 'package:equatable/equatable.dart';

/// Miroir de l'entite backend `Measurement`
/// (ApiTailorManagement/.../Domain/Measurements/Measurement.cs).
class Measurement extends Equatable {
  final String id;
  final String customerId;
  final double? chest;
  final double? waist;
  final double? shoulderWidth;
  final double? sleeveLength;
  final double? trouserLength;
  final double? neckSize;

  const Measurement({
    required this.id,
    required this.customerId,
    this.chest,
    this.waist,
    this.shoulderWidth,
    this.sleeveLength,
    this.trouserLength,
    this.neckSize,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) => Measurement(
        id: json['id'] as String,
        customerId: json['customerId'] as String,
        chest: (json['chest'] as num?)?.toDouble(),
        waist: (json['waist'] as num?)?.toDouble(),
        shoulderWidth: (json['shoulderWidth'] as num?)?.toDouble(),
        sleeveLength: (json['sleeveLength'] as num?)?.toDouble(),
        trouserLength: (json['trouserLength'] as num?)?.toDouble(),
        neckSize: (json['neckSize'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'chest': chest,
        'waist': waist,
        'shoulderWidth': shoulderWidth,
        'sleeveLength': sleeveLength,
        'trouserLength': trouserLength,
        'neckSize': neckSize,
      };

  @override
  List<Object?> get props =>
      [id, customerId, chest, waist, shoulderWidth, sleeveLength, trouserLength, neckSize];
}
