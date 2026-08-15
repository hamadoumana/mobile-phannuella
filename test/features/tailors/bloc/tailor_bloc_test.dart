import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/tailors/domain/entities/tailor.dart';
import 'package:tailor_shop_mobile/features/tailors/domain/repositories/tailor_repository.dart';
import 'package:tailor_shop_mobile/features/tailors/presentation/bloc/tailor_bloc.dart';

class MockTailorRepository extends Mock implements TailorRepository {}

void main() {
  late TailorBloc bloc;
  late MockTailorRepository mockRepository;

  setUp(() {
    mockRepository = MockTailorRepository();
    bloc = TailorBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadTailors', () {
    const fakeTailors = [
      Tailor(
        id: '1',
        name: 'Moussa Sow',
        phoneNumber: '+221700000000',
        city: 'dakar',
        workshopAddress: 'Sandaga',
      ),
    ];

    blocTest<TailorBloc, TailorState>(
      'emet [TailorLoading, TailorLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getTailors()).thenAnswer((_) async => fakeTailors);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTailors()),
      expect: () => [
        const TailorLoading(),
        const TailorLoaded(fakeTailors),
      ],
    );

    blocTest<TailorBloc, TailorState>(
      'emet [TailorLoading, TailorError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getTailors()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTailors()),
      expect: () => [
        const TailorLoading(),
        isA<TailorError>(),
      ],
    );
  });
}
