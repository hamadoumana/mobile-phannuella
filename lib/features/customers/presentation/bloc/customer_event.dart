part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomerEvent {
  const LoadCustomers();
}

class CreateCustomer extends CustomerEvent {
  final Map<String, dynamic> data;
  const CreateCustomer(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteCustomer extends CustomerEvent {
  final String id;
  const DeleteCustomer(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshCustomers extends CustomerEvent {
  const RefreshCustomers();
}
