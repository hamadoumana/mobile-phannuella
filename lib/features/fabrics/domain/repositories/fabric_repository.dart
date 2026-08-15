import '../entities/fabric.dart';

abstract class FabricRepository {
  Future<List<Fabric>> getFabrics();
  Future<Fabric> getFabric(String id);
  Future<Fabric> createFabric(Map<String, dynamic> data);
  Future<void> deleteFabric(String id);
}
