part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoaded extends OrderState {
  final List<Order> orders;
  const OrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderOperationSuccess extends OrderState {
  final String message;
  final Order? order;
  const OrderOperationSuccess(this.message, {this.order});

  @override
  List<Object?> get props => [message, order];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
