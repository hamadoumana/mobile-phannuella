import '../../../../core/network/api_client.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/repositories/measurement_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/MeasurementsController.cs
/// (api/v1/measurements).
class MeasurementRepositoryImpl implements MeasurementRepository {
  final ApiClient _apiClient;

  MeasurementRepositoryImpl(this._apiClient);

  @override
  Future<List<Measurement>> getMeasurements() async {
    final response = await _apiClient.get('/measurements');
    return (response.data as List)
        .map((json) => Measurement.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Measurement> getMeasurement(String id) async {
    final response = await _apiClient.get('/measurements/$id');
    return Measurement.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Measurement> createMeasurement(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/measurements', data: data);
    return Measurement.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteMeasurement(String id) async {
    await _apiClient.delete('/measurements/$id');
  }
}
