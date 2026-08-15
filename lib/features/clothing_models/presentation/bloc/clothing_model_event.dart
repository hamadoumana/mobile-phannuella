part of 'clothing_model_bloc.dart';

abstract class ClothingModelEvent extends Equatable {
  const ClothingModelEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothingModels extends ClothingModelEvent {
  const LoadClothingModels();
}

class CreateClothingModel extends ClothingModelEvent {
  final Map<String, dynamic> data;
  const CreateClothingModel(this.data);

  @override
  List<Object?> get props => [data];
}

class DeleteClothingModel extends ClothingModelEvent {
  final String id;
  const DeleteClothingModel(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshClothingModels extends ClothingModelEvent {
  const RefreshClothingModels();
}
