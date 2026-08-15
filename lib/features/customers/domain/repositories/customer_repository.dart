import '../entities/customer.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers();
  Future<Customer> getCustomer(String id);
  Future<Customer?> getCustomerByPhoneNumber(String phoneNumber);
  Future<Customer> createCustomer(Map<String, dynamic> data);
  Future<void> deleteCustomer(String id);
}
