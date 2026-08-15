part of 'fabric_bloc.dart';

abstract class FabricState extends Equatable {
  const FabricState();

  @override
  List<Object?> get props => [];
}

class FabricInitial extends FabricState {
  const FabricInitial();
}

class FabricLoading extends FabricState {
  const FabricLoading();
}

class FabricLoaded extends FabricState {
  final List<Fabric> fabrics;
  const FabricLoaded(this.fabrics);

  @override
  List<Object?> get props => [fabrics];
}

class FabricOperationSuccess extends FabricState {
  final String message;
  const FabricOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FabricError extends FabricState {
  final String message;
  const FabricError(this.message);

  @override
  List<Object?> get props => [message];
}
