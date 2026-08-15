part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {
  const LoadOrders();
}

class CreateOrder extends OrderEvent {
  final Map<String, dynamic> data;
  const CreateOrder(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteOrder extends OrderEvent {
  final String id;
  const DeleteOrder(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshOrders extends OrderEvent {
  const RefreshOrders();
}
