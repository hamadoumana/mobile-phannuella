import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../network/keycloak_service.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cities/data/repositories/city_repository_impl.dart';
import '../../features/cities/domain/repositories/city_repository.dart';
import '../../features/cities/presentation/bloc/city_bloc.dart';
import '../../features/clothing_models/data/repositories/clothing_model_repository_impl.dart';
import '../../features/clothing_models/domain/repositories/clothing_model_repository.dart';
import '../../features/clothing_models/presentation/bloc/clothing_model_bloc.dart';
import '../../features/customers/data/repositories/customer_repository_impl.dart';
import '../../features/customers/domain/repositories/customer_repository.dart';
import '../../features/customers/presentation/bloc/customer_bloc.dart';
import '../../features/fabrics/data/repositories/fabric_repository_impl.dart';
import '../../features/fabrics/domain/repositories/fabric_repository.dart';
import '../../features/fabrics/presentation/bloc/fabric_bloc.dart';
import '../../features/measurements/data/repositories/measurement_repository_impl.dart';
import '../../features/measurements/domain/repositories/measurement_repository.dart';
import '../../features/measurements/presentation/bloc/measurement_bloc.dart';
import '../../features/order_groups/data/repositories/order_group_repository_impl.dart';
import '../../features/order_groups/domain/repositories/order_group_repository.dart';
import '../../features/order_groups/presentation/bloc/order_group_bloc.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/orders/presentation/bloc/order_bloc.dart';
import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/payments/presentation/bloc/payment_bloc.dart';
import '../../features/tailors/data/repositories/tailor_repository_impl.dart';
import '../../features/tailors/domain/repositories/tailor_repository.dart';
import '../../features/tailors/presentation/bloc/tailor_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // -- Core (singletons) --------------------------------------------------
  sl.registerLazySingleton<KeycloakService>(() => KeycloakService());
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<KeycloakService>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl<ApiClient>()));

  // -- Repositories ---------------------------------------------------------
  sl.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<FabricRepository>(
    () => FabricRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<ClothingModelRepository>(
    () => ClothingModelRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<MeasurementRepository>(
    () => MeasurementRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<TailorRepository>(
    () => TailorRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<CityRepository>(
    () => CityRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<OrderGroupRepository>(
    () => OrderGroupRepositoryImpl(sl<ApiClient>()),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl<ApiClient>()),
  );

  // -- AuthBloc : singleton, l'etat d'authentification est global ----------
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(sl<KeycloakService>(), sl<AuthRepository>()),
  );

  // -- BLoCs de feature (factory : nouvelle instance a chaque utilisation) --
  sl.registerFactory<CustomerBloc>(() => CustomerBloc(sl<CustomerRepository>()));
  sl.registerFactory<OrderBloc>(() => OrderBloc(sl<OrderRepository>()));
  sl.registerFactory<FabricBloc>(() => FabricBloc(sl<FabricRepository>()));
  sl.registerFactory<ClothingModelBloc>(() => ClothingModelBloc(sl<ClothingModelRepository>()));
  sl.registerFactory<MeasurementBloc>(() => MeasurementBloc(sl<MeasurementRepository>()));
  sl.registerFactory<TailorBloc>(() => TailorBloc(sl<TailorRepository>()));
  sl.registerFactory<CityBloc>(() => CityBloc(sl<CityRepository>()));
  sl.registerFactory<OrderGroupBloc>(() => OrderGroupBloc(sl<OrderGroupRepository>()));
  sl.registerFactory<PaymentBloc>(() => PaymentBloc(sl<PaymentRepository>()));
}
