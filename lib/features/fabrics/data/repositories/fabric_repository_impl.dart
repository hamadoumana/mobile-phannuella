import '../../../../core/network/api_client.dart';
import '../../domain/entities/fabric.dart';
import '../../domain/repositories/fabric_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/FabricsController.cs
/// (api/v1/fabrics).
class FabricRepositoryImpl implements FabricRepository {
  final ApiClient _apiClient;

  FabricRepositoryImpl(this._apiClient);

  @override
  Future<List<Fabric>> getFabrics() async {
    final response = await _apiClient.get('/fabrics');
    return (response.data as List)
        .map((json) => Fabric.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Fabric> getFabric(String id) async {
    final response = await _apiClient.get('/fabrics/$id');
    return Fabric.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Fabric> createFabric(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/fabrics', data: data);
    return Fabric.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteFabric(String id) async {
    await _apiClient.delete('/fabrics/$id');
  }
}
