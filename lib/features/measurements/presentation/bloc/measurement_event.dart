part of 'measurement_bloc.dart';

abstract class MeasurementEvent extends Equatable {
  const MeasurementEvent();

  @override
  List<Object?> get props => [];
}

class LoadMeasurements extends MeasurementEvent {
  const LoadMeasurements();
}

class CreateMeasurement extends MeasurementEvent {
  final Map<String, dynamic> data;
  const CreateMeasurement(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteMeasurement extends MeasurementEvent {
  final String id;
  const DeleteMeasurement(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshMeasurements extends MeasurementEvent {
  const RefreshMeasurements();
}
