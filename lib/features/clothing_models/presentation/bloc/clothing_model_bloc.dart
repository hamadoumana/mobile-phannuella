import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/clothing_model.dart';
import '../../domain/repositories/clothing_model_repository.dart';

part 'clothing_model_event.dart';
part 'clothing_model_state.dart';

class ClothingModelBloc extends Bloc<ClothingModelEvent, ClothingModelState> {
  final ClothingModelRepository _repository;

  ClothingModelBloc(this._repository) : super(const ClothingModelInitial()) {
    on<LoadClothingModels>(_onLoadClothingModels);
    on<CreateClothingModel>(_onCreateClothingModel);
    on<DeleteClothingModel>(_onDeleteClothingModel);
    on<RefreshClothingModels>(_onRefreshClothingModels);
  }

  Future<void> _onLoadClothingModels(
    LoadClothingModels event,
    Emitter<ClothingModelState> emit,
  ) async {
    emit(const ClothingModelLoading());
    try {
      final clothingModels = await _repository.getClothingModels();
      emit(ClothingModelLoaded(clothingModels));
    } catch (e) {
      emit(ClothingModelError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onCreateClothingModel(
    CreateClothingModel event,
    Emitter<ClothingModelState> emit,
  ) async {
    try {
      await _repository.createClothingModel(event.data);
      emit(const ClothingModelOperationSuccess('Modele cree avec succes'));
      add(const RefreshClothingModels());
    } catch (e) {
      emit(ClothingModelError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onDeleteClothingModel(
    DeleteClothingModel event,
    Emitter<ClothingModelState> emit,
  ) async {
    try {
      await _repository.deleteClothingModel(event.id);
      if (state is ClothingModelLoaded) {
        final current = (state as ClothingModelLoaded).clothingModels;
        emit(ClothingModelLoaded(current.where((m) => m.id != event.id).toList()));
      }
    } catch (e) {
      emit(ClothingModelError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshClothingModels(
    RefreshClothingModels event,
    Emitter<ClothingModelState> emit,
  ) async {
    add(const LoadClothingModels());
  }
}
