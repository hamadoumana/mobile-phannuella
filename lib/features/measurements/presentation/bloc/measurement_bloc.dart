import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/repositories/measurement_repository.dart';

part 'measurement_event.dart';
part 'measurement_state.dart';

class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  final MeasurementRepository _repository;

  MeasurementBloc(this._repository) : super(const MeasurementInitial()) {
    on<LoadMeasurements>(_onLoadMeasurements);
    on<CreateMeasurement>(_onCreateMeasurement);
    on<DeleteMeasurement>(_onDeleteMeasurement);
    on<RefreshMeasurements>(_onRefreshMeasurements);
  }

  Future<void> _onLoadMeasurements(LoadMeasurements event, Emitter<MeasurementState> emit) async {
    emit(const MeasurementLoading());
    try {
      final measurements = await _repository.getMeasurements();
      emit(MeasurementLoaded(measurements));
    } catch (e) {
      emit(MeasurementError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onCreateMeasurement(
    CreateMeasurement event,
    Emitter<MeasurementState> emit,
  ) async {
    try {
      await _repository.createMeasurement(event.data);
      emit(const MeasurementOperationSuccess('Mesure creee avec succes'));
      add(const RefreshMeasurements());
    } catch (e) {
      emit(MeasurementError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onDeleteMeasurement(
    DeleteMeasurement event,
    Emitter<MeasurementState> emit,
  ) async {
    try {
      await _repository.deleteMeasurement(event.id);
      if (state is MeasurementLoaded) {
        final current = (state as MeasurementLoaded).measurements;
        emit(MeasurementLoaded(current.where((m) => m.id != event.id).toList()));
      }
    } catch (e) {
      emit(MeasurementError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshMeasurements(
    RefreshMeasurements event,
    Emitter<MeasurementState> emit,
  ) async {
    add(const LoadMeasurements());
  }
}
