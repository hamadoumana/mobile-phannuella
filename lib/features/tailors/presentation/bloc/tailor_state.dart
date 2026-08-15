part of 'tailor_bloc.dart';

abstract class TailorState extends Equatable {
  const TailorState();

  @override
  List<Object?> get props => [];
}

class TailorInitial extends TailorState {
  const TailorInitial();
}

class TailorLoading extends TailorState {
  const TailorLoading();
}

class TailorLoaded extends TailorState {
  final List<Tailor> tailors;
  const TailorLoaded(this.tailors);

  @override
  List<Object?> get props => [tailors];
}

class TailorOperationSuccess extends TailorState {
  final String message;
  const TailorOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TailorError extends TailorState {
  final String message;
  const TailorError(this.message);

  @override
  List<Object?> get props => [message];
}
