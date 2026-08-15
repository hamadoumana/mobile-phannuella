import '../entities/tailor.dart';

abstract class TailorRepository {
  Future<List<Tailor>> getTailors();
  Future<Tailor> getTailor(String id);
  Future<Tailor> createTailor(Map<String, dynamic> data);
  Future<void> deleteTailor(String id);
}
