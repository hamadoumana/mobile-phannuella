import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _repository;

  OrderBloc(this._repository) : super(const OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<DeleteOrder>(_onDeleteOrder);
    on<RefreshOrders>(_onRefreshOrders);
  }

  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orders = await _repository.getOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onCreateOrder(CreateOrder event, Emitter<OrderState> emit) async {
    try {
      final order = await _repository.createOrder(event.data);
      emit(OrderOperationSuccess('Commande creee avec succes', order: order));
      add(const RefreshOrders());
    } catch (e) {
      emit(OrderError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onDeleteOrder(DeleteOrder event, Emitter<OrderState> emit) async {
    try {
      await _repository.deleteOrder(event.id);
      if (state is OrderLoaded) {
        final current = (state as OrderLoaded).orders;
        emit(OrderLoaded(current.where((o) => o.id != event.id).toList()));
      }
    } catch (e) {
      emit(OrderError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshOrders(RefreshOrders event, Emitter<OrderState> emit) async {
    add(const LoadOrders());
  }
}
