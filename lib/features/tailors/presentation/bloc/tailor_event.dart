part of 'tailor_bloc.dart';

abstract class TailorEvent extends Equatable {
  const TailorEvent();

  @override
  List<Object?> get props => [];
}

class LoadTailors extends TailorEvent {
  const LoadTailors();
}

class CreateTailor extends TailorEvent {
  final Map<String, dynamic> data;
  const CreateTailor(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteTailor extends TailorEvent {
  final String id;
  const DeleteTailor(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshTailors extends TailorEvent {
  const RefreshTailors();
}
