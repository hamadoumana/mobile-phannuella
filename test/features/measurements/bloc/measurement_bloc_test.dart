import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/measurements/domain/entities/measurement.dart';
import 'package:tailor_shop_mobile/features/measurements/domain/repositories/measurement_repository.dart';
import 'package:tailor_shop_mobile/features/measurements/presentation/bloc/measurement_bloc.dart';

class MockMeasurementRepository extends Mock implements MeasurementRepository {}

void main() {
  late MeasurementBloc bloc;
  late MockMeasurementRepository mockRepository;

  setUp(() {
    mockRepository = MockMeasurementRepository();
    bloc = MeasurementBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadMeasurements', () {
    const fakeMeasurements = [
      Measurement(id: '1', customerId: 'customer-1', chest: 96, waist: 82, shoulderWidth: 45),
    ];

    blocTest<MeasurementBloc, MeasurementState>(
      'emet [MeasurementLoading, MeasurementLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getMeasurements()).thenAnswer((_) async => fakeMeasurements);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMeasurements()),
      expect: () => [
        const MeasurementLoading(),
        const MeasurementLoaded(fakeMeasurements),
      ],
    );

    blocTest<MeasurementBloc, MeasurementState>(
      'emet [MeasurementLoading, MeasurementError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getMeasurements()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadMeasurements()),
      expect: () => [
        const MeasurementLoading(),
        isA<MeasurementError>(),
      ],
    );
  });
}
