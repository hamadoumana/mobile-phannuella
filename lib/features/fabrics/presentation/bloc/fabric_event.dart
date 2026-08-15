part of 'fabric_bloc.dart';

abstract class FabricEvent extends Equatable {
  const FabricEvent();

  @override
  List<Object?> get props => [];
}

class LoadFabrics extends FabricEvent {
  const LoadFabrics();
}

class CreateFabric extends FabricEvent {
  final Map<String, dynamic> data;
  const CreateFabric(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteFabric extends FabricEvent {
  final String id;
  const DeleteFabric(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshFabrics extends FabricEvent {
  const RefreshFabrics();
}
