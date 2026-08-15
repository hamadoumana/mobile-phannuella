part of 'order_group_bloc.dart';

abstract class OrderGroupEvent extends Equatable {
  const OrderGroupEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderGroups extends OrderGroupEvent {
  const LoadOrderGroups();
}

class CreateOrderGroup extends OrderGroupEvent {
  final Map<String, dynamic> data;
  const CreateOrderGroup(this.data);

  @override
  List<Object?> get props => [data];
}

class RefreshOrderGroups extends OrderGroupEvent {
  const RefreshOrderGroups();
}
