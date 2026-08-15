import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/fabric.dart';
import '../../domain/repositories/fabric_repository.dart';

part 'fabric_event.dart';
part 'fabric_state.dart';

class FabricBloc extends Bloc<FabricEvent, FabricState> {
  final FabricRepository _repository;

  FabricBloc(this._repository) : super(const FabricInitial()) {
    on<LoadFabrics>(_onLoadFabrics);
    on<CreateFabric>(_onCreateFabric);
    on<DeleteFabric>(_onDeleteFabric);
    on<RefreshFabrics>(_onRefreshFabrics);
  }

  Future<void> _onLoadFabrics(LoadFabrics event, Emitter<FabricState> emit) async {
    emit(const FabricLoading());
    try {
      final fabrics = await _repository.getFabrics();
      emit(FabricLoaded(fabrics));
    } catch (e) {
      emit(FabricError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onCreateFabric(CreateFabric event, Emitter<FabricState> emit) async {
    try {
      await _repository.createFabric(event.data);
      emit(const FabricOperationSuccess('Tissu cree avec succes'));
      add(const RefreshFabrics());
    } catch (e) {
      emit(FabricError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onDeleteFabric(DeleteFabric event, Emitter<FabricState> emit) async {
    try {
      await _repository.deleteFabric(event.id);
      if (state is FabricLoaded) {
        final current = (state as FabricLoaded).fabrics;
        emit(FabricLoaded(current.where((f) => f.id != event.id).toList()));
      }
    } catch (e) {
      emit(FabricError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshFabrics(RefreshFabrics event, Emitter<FabricState> emit) async {
    add(const LoadFabrics());
  }
}
