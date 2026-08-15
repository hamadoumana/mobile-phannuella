import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:tailor_shop_mobile/features/customers/domain/entities/customer.dart';
import 'package:tailor_shop_mobile/features/customers/domain/repositories/customer_repository.dart';
import 'package:tailor_shop_mobile/features/customers/presentation/bloc/customer_bloc.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  late CustomerBloc bloc;
  late MockCustomerRepository mockRepository;

  setUp(() {
    mockRepository = MockCustomerRepository();
    bloc = CustomerBloc(mockRepository);
  });

  tearDown(() => bloc.close());

  group('LoadCustomers', () {
    const fakeCustomers = [
      Customer(
        id: '1',
        firstName: 'Awa',
        lastName: 'Diop',
        phoneNumber: '+221700000000',
        city: 'dakar',
      ),
    ];

    blocTest<CustomerBloc, CustomerState>(
      'emet [CustomerLoading, CustomerLoaded] quand la liste est chargee avec succes',
      build: () {
        when(() => mockRepository.getCustomers()).thenAnswer((_) async => fakeCustomers);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCustomers()),
      expect: () => [
        const CustomerLoading(),
        const CustomerLoaded(fakeCustomers),
      ],
    );

    blocTest<CustomerBloc, CustomerState>(
      'emet [CustomerLoading, CustomerError] quand le chargement echoue',
      build: () {
        when(() => mockRepository.getCustomers()).thenThrow(Exception('Erreur reseau'));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadCustomers()),
      expect: () => [
        const CustomerLoading(),
        isA<CustomerError>(),
      ],
    );
  });
}
