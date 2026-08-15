import '../../../../core/network/api_client.dart';
import '../../domain/entities/clothing_model.dart';
import '../../domain/repositories/clothing_model_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/ClothingModelsController.cs
/// (api/v1/clothingmodels).
class ClothingModelRepositoryImpl implements ClothingModelRepository {
  final ApiClient _apiClient;

  ClothingModelRepositoryImpl(this._apiClient);

  @override
  Future<List<ClothingModel>> getClothingModels() async {
    final response = await _apiClient.get('/clothingmodels');
    return (response.data as List)
        .map((json) => ClothingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ClothingModel> getClothingModel(String id) async {
    final response = await _apiClient.get('/clothingmodels/$id');
    return ClothingModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ClothingModel> createClothingModel(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/clothingmodels', data: data);
    return ClothingModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteClothingModel(String id) async {
    await _apiClient.delete('/clothingmodels/$id');
  }
}
