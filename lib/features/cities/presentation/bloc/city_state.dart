part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {
  const CityInitial();
}

class CityLoading extends CityState {
  const CityLoading();
}

class CityLoaded extends CityState {
  final List<City> cities;
  const CityLoaded(this.cities);

  @override
  List<Object?> get props => [cities];
}

class CityError extends CityState {
  final String message;
  const CityError(this.message);

  @override
  List<Object?> get props => [message];
}
