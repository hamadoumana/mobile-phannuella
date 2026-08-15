import '../../../../core/network/api_client.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/city_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/CitiesController.cs
/// (api/v1/cities -- GET uniquement cote mobile).
class CityRepositoryImpl implements CityRepository {
  final ApiClient _apiClient;

  CityRepositoryImpl(this._apiClient);

  @override
  Future<List<City>> getCities() async {
    final response = await _apiClient.get('/cities');
    return (response.data as List)
        .map((json) => City.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
