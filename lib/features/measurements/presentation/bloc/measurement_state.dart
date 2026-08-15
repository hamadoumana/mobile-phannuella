part of 'measurement_bloc.dart';

abstract class MeasurementState extends Equatable {
  const MeasurementState();

  @override
  List<Object?> get props => [];
}

class MeasurementInitial extends MeasurementState {
  const MeasurementInitial();
}

class MeasurementLoading extends MeasurementState {
  const MeasurementLoading();
}

class MeasurementLoaded extends MeasurementState {
  final List<Measurement> measurements;
  const MeasurementLoaded(this.measurements);

  @override
  List<Object?> get props => [measurements];
}

class MeasurementOperationSuccess extends MeasurementState {
  final String message;
  const MeasurementOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MeasurementError extends MeasurementState {
  final String message;
  const MeasurementError(this.message);

  @override
  List<Object?> get props => [message];
}
