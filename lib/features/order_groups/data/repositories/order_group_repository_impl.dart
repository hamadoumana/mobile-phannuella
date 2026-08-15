import '../../../../core/network/api_client.dart';
import '../../domain/entities/order_group.dart';
import '../../domain/repositories/order_group_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/OrderGroupsController.cs
/// (api/v1/order-groups -- pas de PUT/DELETE cote backend).
class OrderGroupRepositoryImpl implements OrderGroupRepository {
  final ApiClient _apiClient;

  OrderGroupRepositoryImpl(this._apiClient);

  @override
  Future<List<OrderGroup>> getOrderGroups() async {
    final response = await _apiClient.get('/order-groups');
    return (response.data as List)
        .map((json) => OrderGroup.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderGroup> getOrderGroup(String id) async {
    final response = await _apiClient.get('/order-groups/$id');
    return OrderGroup.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<OrderGroup> createOrderGroup(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/order-groups', data: data);
    return OrderGroup.fromJson(response.data as Map<String, dynamic>);
  }
}
