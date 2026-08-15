import '../../../../core/network/api_client.dart';
import '../../domain/entities/tailor.dart';
import '../../domain/repositories/tailor_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/TailorsController.cs
/// (api/v1/tailors).
class TailorRepositoryImpl implements TailorRepository {
  final ApiClient _apiClient;

  TailorRepositoryImpl(this._apiClient);

  @override
  Future<List<Tailor>> getTailors() async {
    final response = await _apiClient.get('/tailors');
    return (response.data as List)
        .map((json) => Tailor.fromJson(json as Map<String, dynamic>))
        .toList();
  } 

  @override
  Future<Tailor> getTailor(String id) async {
    final response = await _apiClient.get('/tailors/$id');
    return Tailor.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Tailor> createTailor(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/tailors', data: data);
    return Tailor.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTailor(String id) async {
    await _apiClient.delete('/tailors/$id');
  }
}
