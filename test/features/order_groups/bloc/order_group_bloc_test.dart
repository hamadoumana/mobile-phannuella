import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/order_groups/domain/entities/order_group.dart';
import 'package:tailor_shop_mobile/features/order_groups/domain/repositories/order_group_repository.dart';
import 'package:tailor_shop_mobile/features/order_groups/presentation/bloc/order_group_bloc.dart';

class MockOrderGroupRepository extends Mock implements OrderGroupRepository {}

void main() {
  late OrderGroupBloc bloc;
  late MockOrderGroupRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderGroupRepository();
    bloc = OrderGroupBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadOrderGroups', () {
    const fakeOrderGroups = [
      OrderGroup(
        id: '1',
        customerId: 'customer-1',
        orderNumber: 'CMD-0001',
        totalAmount: 30000,
        advancePayment: 10000,
        balance: 20000,
        status: 'en_attente',
      ),
    ];

    blocTest<OrderGroupBloc, OrderGroupState>(
      'emet [OrderGroupLoading, OrderGroupLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getOrderGroups()).thenAnswer((_) async => fakeOrderGroups);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadOrderGroups()),
      expect: () => [
        const OrderGroupLoading(),
        const OrderGroupLoaded(fakeOrderGroups),
      ],
    );

    blocTest<OrderGroupBloc, OrderGroupState>(
      'emet [OrderGroupLoading, OrderGroupError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getOrderGroups()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadOrderGroups()),
      expect: () => [
        const OrderGroupLoading(),
        isA<OrderGroupError>(),
      ],
    );
  });
}
