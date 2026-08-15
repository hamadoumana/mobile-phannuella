import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/clothing_models/domain/entities/clothing_model.dart';
import 'package:tailor_shop_mobile/features/clothing_models/domain/repositories/clothing_model_repository.dart';
import 'package:tailor_shop_mobile/features/clothing_models/presentation/bloc/clothing_model_bloc.dart';

class MockClothingModelRepository extends Mock implements ClothingModelRepository {}

void main() {
  late ClothingModelBloc bloc;
  late MockClothingModelRepository mockRepository;

  setUp(() {
    mockRepository = MockClothingModelRepository();
    bloc = ClothingModelBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadClothingModels', () {
    const fakeModels = [
      ClothingModel(id: '1', modelName: 'Boubou', description: 'Boubou brode', unitPrice: 25000),
    ];

    blocTest<ClothingModelBloc, ClothingModelState>(
      'emet [ClothingModelLoading, ClothingModelLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getClothingModels()).thenAnswer((_) async => fakeModels);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadClothingModels()),
      expect: () => [
        const ClothingModelLoading(),
        const ClothingModelLoaded(fakeModels),
      ],
    );

    blocTest<ClothingModelBloc, ClothingModelState>(
      'emet [ClothingModelLoading, ClothingModelError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getClothingModels()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadClothingModels()),
      expect: () => [
        const ClothingModelLoading(),
        isA<ClothingModelError>(),
      ],
    );
  });
}
