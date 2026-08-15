import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/cities/domain/entities/city.dart';
import 'package:tailor_shop_mobile/features/cities/domain/repositories/city_repository.dart';
import 'package:tailor_shop_mobile/features/cities/presentation/bloc/city_bloc.dart';

class MockCityRepository extends Mock implements CityRepository {}

void main() {
  late CityBloc bloc;
  late MockCityRepository mockRepository;

  setUp(() {
    mockRepository = MockCityRepository();
    bloc = CityBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadCities', () {
    const fakeCities = [
      City(id: '1', code: 'dkr', name: 'Dakar', isActive: true),
    ];

    blocTest<CityBloc, CityState>(
      'emet [CityLoading, CityLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getCities()).thenAnswer((_) async => fakeCities);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCities()),
      expect: () => [
        const CityLoading(),
        const CityLoaded(fakeCities),
      ],
    );

    blocTest<CityBloc, CityState>(
      'emet [CityLoading, CityError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getCities()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCities()),
      expect: () => [
        const CityLoading(),
        isA<CityError>(),
      ],
    );
  });
}
