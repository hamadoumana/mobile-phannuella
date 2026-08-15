import 'package:equatable/equatable.dart';

/// Miroir de l'entite backend `Fabric`
/// (ApiTailorManagement/.../Domain/Fabrics/Fabric.cs).
class Fabric extends Equatable {
  final String id;
  final String fabricName;
  final String? color;
  final String? material;
  final double pricePerMeter;
  final double quantityAvailable;

  const Fabric({
    required this.id,
    required this.fabricName,
    this.color,
    this.material,
    required this.pricePerMeter,
    required this.quantityAvailable,
  });

  factory Fabric.fromJson(Map<String, dynamic> json) => Fabric(
        id: json['id'] as String,
        fabricName: json['fabricName'] as String,
        color: json['color'] as String?,
        material: json['material'] as String?,
        pricePerMeter: (json['pricePerMeter'] as num).toDouble(),
        quantityAvailable: (json['quantityAvailable'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fabricName': fabricName,
        'color': color,
        'material': material,
        'pricePerMeter': pricePerMeter,
        'quantityAvailable': quantityAvailable,
      };

  @override
  List<Object?> get props => [id, fabricName, color, material, pricePerMeter, quantityAvailable];
}
