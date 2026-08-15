part of 'order_group_bloc.dart';

abstract class OrderGroupState extends Equatable {
  const OrderGroupState();

  @override
  List<Object?> get props => [];
}

class OrderGroupInitial extends OrderGroupState {
  const OrderGroupInitial();
}

class OrderGroupLoading extends OrderGroupState {
  const OrderGroupLoading();
}

class OrderGroupLoaded extends OrderGroupState {
  final List<OrderGroup> orderGroups;
  const OrderGroupLoaded(this.orderGroups);

  @override
  List<Object?> get props => [orderGroups];
}

class OrderGroupOperationSuccess extends OrderGroupState {
  final String message;
  const OrderGroupOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderGroupError extends OrderGroupState {
  final String message;
  const OrderGroupError(this.message);

  @override
  List<Object?> get props => [message];
}
