import '../entities/measurement.dart';

abstract class MeasurementRepository {
  Future<List<Measurement>> getMeasurements();
  Future<Measurement> getMeasurement(String id);
  Future<Measurement> createMeasurement(Map<String, dynamic> data);
  Future<void> deleteMeasurement(String id);
}
