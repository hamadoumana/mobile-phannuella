import '../../../../core/network/api_client.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/CustomersController.cs
/// (api/v1/customers).
class CustomerRepositoryImpl implements CustomerRepository {
  final ApiClient _apiClient;

  CustomerRepositoryImpl(this._apiClient);

  @override
  Future<List<Customer>> getCustomers() async {
    final response = await _apiClient.get('/customers');
    return (response.data as List)
        .map((json) => Customer.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Customer> getCustomer(String id) async {
    final response = await _apiClient.get('/customers/$id');
    return Customer.fromJson(response.data as Map<String, dynamic>);
  }

  /// Utilise le filtre QueryKit du backend (`Filters=PhoneNumber == "..."`)
  /// pour retrouver le Customer associe au numero de telephone connecte
  /// (= username Keycloak), sans avoir a charger toute la liste des clients.
  @override
  Future<Customer?> getCustomerByPhoneNumber(String phoneNumber) async {
    final response = await _apiClient.get(
      '/customers',
      queryParams: {'Filters': 'PhoneNumber == "$phoneNumber"', 'PageSize': 1},
    );
    final results = (response.data as List)
        .map((json) => Customer.fromJson(json as Map<String, dynamic>))
        .toList();
    return results.isEmpty ? null : results.first;
  }

  @override
  Future<Customer> createCustomer(Map<String, dynamic> data) async {
    final response = await _apiClient.post('/customers', data: data);
    return Customer.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteCustomer(String id) async {
    await _apiClient.delete('/customers/$id');
  }
}
