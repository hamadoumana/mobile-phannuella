import '../entities/clothing_model.dart';

abstract class ClothingModelRepository {
  Future<List<ClothingModel>> getClothingModels();
  Future<ClothingModel> getClothingModel(String id);
  Future<ClothingModel> createClothingModel(Map<String, dynamic> data);
  Future<void> deleteClothingModel(String id);
}
