import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/city_repository.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository _repository;

  CityBloc(this._repository) : super(const CityInitial()) {
    on<LoadCities>(_onLoadCities);
    on<RefreshCities>(_onRefreshCities);
  }

  Future<void> _onLoadCities(LoadCities event, Emitter<CityState> emit) async {
    emit(const CityLoading());
    try {
      final cities = await _repository.getCities();
      emit(CityLoaded(cities));
    } catch (e) {
      emit(CityError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onRefreshCities(RefreshCities event, Emitter<CityState> emit) async {
    add(const LoadCities());
  }
}
