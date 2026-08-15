import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/tailor.dart';
import '../../domain/repositories/tailor_repository.dart';

part 'tailor_event.dart';
part 'tailor_state.dart';

class TailorBloc extends Bloc<TailorEvent, TailorState> {
  final TailorRepository _repository;

  TailorBloc(this._repository) : super(const TailorInitial()) {
    on<LoadTailors>(_onLoadTailors);
    on<CreateTailor>(_onCreateTailor);
    on<DeleteTailor>(_onDeleteTailor);
    on<RefreshTailors>(_onRefreshTailors);
  }

  Future<void> _onLoadTailors(LoadTailors event, Emitter<TailorState> emit) async {
    emit(const TailorLoading());
    try {
      final tailors = await _repository.getTailors();
      emit(TailorLoaded(tailors));
    } catch (e) {
      emit(TailorError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onCreateTailor(CreateTailor event, Emitter<TailorState> emit) async {
    try {
      await _repository.createTailor(event.data);
      emit(const TailorOperationSuccess('Couturier cree avec succes'));
      add(const RefreshTailors());
    } catch (e) {
      emit(TailorError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onDeleteTailor(DeleteTailor event, Emitter<TailorState> emit) async {
    try {
      await _repository.deleteTailor(event.id);
      if (state is TailorLoaded) {
        final current = (state as TailorLoaded).tailors;
        emit(TailorLoaded(current.where((t) => t.id != event.id).toList()));
      }
    } catch (e) {
      emit(TailorError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshTailors(RefreshTailors event, Emitter<TailorState> emit) async {
    add(const LoadTailors());
  }
}
