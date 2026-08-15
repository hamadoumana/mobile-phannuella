import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders();
  Future<Order> getOrder(String id);
  Future<Order> createOrder(Map<String, dynamic> data);
  Future<void> deleteOrder(String id);
}
