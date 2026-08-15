import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository _repository;

  CustomerBloc(this._repository) : super(const CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<CreateCustomer>(_onCreateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
    on<RefreshCustomers>(_onRefreshCustomers);
  }

  Future<void> _onLoadCustomers(LoadCustomers event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    try {
      final customers = await _repository.getCustomers();
      emit(CustomerLoaded(customers));
    } catch (e) {
      emit(CustomerError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onCreateCustomer(CreateCustomer event, Emitter<CustomerState> emit) async {
    try {
      await _repository.createCustomer(event.data);
      emit(const CustomerOperationSuccess('Client cree avec succes'));
      add(const RefreshCustomers());
    } catch (e) {
      emit(CustomerError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onDeleteCustomer(DeleteCustomer event, Emitter<CustomerState> emit) async {
    try {
      await _repository.deleteCustomer(event.id);
      if (state is CustomerLoaded) {
        final current = (state as CustomerLoaded).customers;
        emit(CustomerLoaded(current.where((c) => c.id != event.id).toList()));
      }
    } catch (e) {
      emit(CustomerError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshCustomers(RefreshCustomers event, Emitter<CustomerState> emit) async {
    add(const LoadCustomers());
  }
}
