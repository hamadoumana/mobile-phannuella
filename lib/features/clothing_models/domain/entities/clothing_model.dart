import 'package:equatable/equatable.dart';

/// Miroir de l'entite backend `ClothingModel`
/// (ApiTailorManagement/.../Domain/ClothingModels/ClothingModel.cs).
class ClothingModel extends Equatable {
  final String id;
  final String modelName;
  final String? category;
  final double unitPrice;
  final String? description;
  final String? photoUrl;

  const ClothingModel({
    required this.id,
    required this.modelName,
    this.category,
    required this.unitPrice,
    this.description,
    this.photoUrl,
  });

  factory ClothingModel.fromJson(Map<String, dynamic> json) => ClothingModel(
        id: json['id'] as String,
        modelName: json['modelName'] as String,
        category: json['category'] as String?,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        description: json['description'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'modelName': modelName,
        'category': category,
        'unitPrice': unitPrice,
        'description': description,
        'photoUrl': photoUrl,
      };

  @override
  List<Object?> get props => [id, modelName, category, unitPrice, description, photoUrl];
}
