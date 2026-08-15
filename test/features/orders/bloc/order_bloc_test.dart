import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/orders/domain/entities/order.dart';
import 'package:tailor_shop_mobile/features/orders/domain/repositories/order_repository.dart';
import 'package:tailor_shop_mobile/features/orders/presentation/bloc/order_bloc.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late OrderBloc bloc;
  late MockOrderRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderRepository();
    bloc = OrderBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadOrders', () {
    final fakeOrders = [
      Order(
        id: '1',
        customerId: 'customer-1',
        clothingModelId: 'model-1',
        fabricId: 'fabric-1',
        quantity: 1,
        unitPrice: 15000,
        totalPrice: 15000,
        orderDate: DateTime(2026, 1, 1),
        deliveryDate: DateTime(2026, 1, 15),
        status: OrderStatus.enAttente,
      ),
    ];

    blocTest<OrderBloc, OrderState>(
      'emet [OrderLoading, OrderLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getOrders()).thenAnswer((_) async => fakeOrders);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadOrders()),
      expect: () => [
        const OrderLoading(),
        OrderLoaded(fakeOrders),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emet [OrderLoading, OrderError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getOrders()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadOrders()),
      expect: () => [
        const OrderLoading(),
        isA<OrderError>(),
      ],
    );
  });
}
