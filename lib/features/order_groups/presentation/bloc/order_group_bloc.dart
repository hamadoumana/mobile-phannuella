import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/order_group.dart';
import '../../domain/repositories/order_group_repository.dart';

part 'order_group_event.dart';
part 'order_group_state.dart';

class OrderGroupBloc extends Bloc<OrderGroupEvent, OrderGroupState> {
  final OrderGroupRepository _repository;

  OrderGroupBloc(this._repository) : super(const OrderGroupInitial()) {
    on<LoadOrderGroups>(_onLoadOrderGroups);
    on<CreateOrderGroup>(_onCreateOrderGroup);
    on<RefreshOrderGroups>(_onRefreshOrderGroups);
  }

  Future<void> _onLoadOrderGroups(LoadOrderGroups event, Emitter<OrderGroupState> emit) async {
    emit(const OrderGroupLoading());
    try {
      final orderGroups = await _repository.getOrderGroups();
      emit(OrderGroupLoaded(orderGroups));
    } catch (e) {
      emit(OrderGroupError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onCreateOrderGroup(CreateOrderGroup event, Emitter<OrderGroupState> emit) async {
    try {
      await _repository.createOrderGroup(event.data);
      emit(const OrderGroupOperationSuccess('Commande groupee creee avec succes'));
      add(const RefreshOrderGroups());
    } catch (e) {
      emit(OrderGroupError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshOrderGroups(RefreshOrderGroups event, Emitter<OrderGroupState> emit) async {
    add(const LoadOrderGroups());
  }
}
