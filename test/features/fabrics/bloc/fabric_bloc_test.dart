import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/fabrics/domain/entities/fabric.dart';
import 'package:tailor_shop_mobile/features/fabrics/domain/repositories/fabric_repository.dart';
import 'package:tailor_shop_mobile/features/fabrics/presentation/bloc/fabric_bloc.dart';

class MockFabricRepository extends Mock implements FabricRepository {}

void main() {
  late FabricBloc bloc;
  late MockFabricRepository mockRepository;

  setUp(() {
    mockRepository = MockFabricRepository();
    bloc = FabricBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadFabrics', () {
    const fakeFabrics = [
      Fabric(id: '1', fabricName: 'Bazin', color: 'Bleu', pricePerMeter: 5000, quantityAvailable: 20),
    ];

    blocTest<FabricBloc, FabricState>(
      'emet [FabricLoading, FabricLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getFabrics()).thenAnswer((_) async => fakeFabrics);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadFabrics()),
      expect: () => [
        const FabricLoading(),
        const FabricLoaded(fakeFabrics),
      ],
    );

    blocTest<FabricBloc, FabricState>(
      'emet [FabricLoading, FabricError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getFabrics()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadFabrics()),
      expect: () => [
        const FabricLoading(),
        isA<FabricError>(),
      ],
    );
  });
}
