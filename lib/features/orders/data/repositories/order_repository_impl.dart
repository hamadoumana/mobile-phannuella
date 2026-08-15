import '../../../../core/network/api_client.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/OrdersController.cs
/// (api/v1/orders). Voir aussi `api/v1/order-groups` (OrderGroups, non couvert
/// par cette feature) pour le regroupement de plusieurs Orders sous une
/// commande globale.
class OrderRepositoryImpl implements OrderRepository {
  final ApiClient _apiClient;

  OrderRepositoryImpl(this._apiClient);

  @override
  Future<List<Order>> getOrders() async {
    final response = await _apiClient.get('/orders');
    return (response.data as List)
        .map((json) => Order.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Order> getOrder(String id) async {
    final response = await _apiClient.get('/orders/$id');
    return Order.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Order> createOrder(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/orders', data: data);
    return Order.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteOrder(String id) async {
    await _apiClient.delete('/orders/$id');
  }
}
