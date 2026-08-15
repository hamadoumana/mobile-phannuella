part of 'clothing_model_bloc.dart';

abstract class ClothingModelState extends Equatable {
  const ClothingModelState();

  @override
  List<Object?> get props => [];
}

class ClothingModelInitial extends ClothingModelState {
  const ClothingModelInitial();
}

class ClothingModelLoading extends ClothingModelState {
  const ClothingModelLoading();
}

class ClothingModelLoaded extends ClothingModelState {
  final List<ClothingModel> clothingModels;
  const ClothingModelLoaded(this.clothingModels);

  @override
  List<Object?> get props => [clothingModels];
}

class ClothingModelOperationSuccess extends ClothingModelState {
  final String message;
  const ClothingModelOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ClothingModelError extends ClothingModelState {
  final String message;
  const ClothingModelError(this.message);

  @override
  List<Object?> get props => [message];
}
