import '../entities/order_group.dart';

abstract class OrderGroupRepository {
  Future<List<OrderGroup>> getOrderGroups();
  Future<OrderGroup> getOrderGroup(String id);
  Future<OrderGroup> createOrderGroup(Map<String, dynamic> data);
}
