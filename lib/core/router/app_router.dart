import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/pages/account_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/cities/presentation/bloc/city_bloc.dart';
import '../../features/cities/presentation/pages/city_list_page.dart';
import '../../features/customers/presentation/bloc/customer_bloc.dart';
import '../../features/customers/presentation/pages/customer_list_page.dart';
import '../../features/fabrics/presentation/bloc/fabric_bloc.dart';
import '../../features/fabrics/presentation/pages/fabric_list_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/notifications_page.dart';
import '../../features/order_groups/presentation/bloc/order_group_bloc.dart';
import '../../features/order_groups/presentation/pages/order_group_list_page.dart';
import '../../features/tailors/presentation/bloc/tailor_bloc.dart';
import '../../features/tailors/presentation/pages/tailor_list_page.dart';
import '../di/injection_container.dart';
import '../network/keycloak_service.dart';

/// Modeles/Mesures/Commandes sont integres directement dans les onglets de
/// [HomePage] (barre de navigation principale). Les routes ci-dessous
/// restent accessibles depuis le tiroir (Drawer) pour la gestion des
/// donnees de reference utilisees lors de la creation d'une mesure/commande
/// (clients, tissus, couturiers, villes, commandes groupees).
final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final isLoggedIn = await sl<KeycloakService>().isLoggedIn();
    final isOnLogin = state.matchedLocation == '/login';
    final isOnRegister = state.matchedLocation == '/register';
    final isOnResetPassword = state.matchedLocation == '/reset-password';
    final isOnPublicAuthRoute = isOnLogin || isOnRegister || isOnResetPassword;

    if (!isLoggedIn && !isOnPublicAuthRoute) return '/login';
    if (isLoggedIn && isOnPublicAuthRoute) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => BlocProvider.value(value: sl<AuthBloc>(), child: const LoginPage()),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => BlocProvider.value(value: sl<AuthBloc>(), child: const RegisterPage()),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (_, __) =>
          BlocProvider.value(value: sl<AuthBloc>(), child: const ResetPasswordPage()),
    ),
    GoRoute(
      path: '/home',
      builder: (_, __) => BlocProvider.value(value: sl<AuthBloc>(), child: const HomePage()),
    ),
    GoRoute(
      path: '/account',
      builder: (_, __) => const AccountPage(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (_, __) => const NotificationsPage(),
    ),
    GoRoute(
      path: '/customers',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<CustomerBloc>()..add(const LoadCustomers()),
        child: const CustomerListPage(),
      ),
    ),
    GoRoute(
      path: '/fabrics',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<FabricBloc>()..add(const LoadFabrics()),
        child: const FabricListPage(),
      ),
    ),
    GoRoute(
      path: '/tailors',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<TailorBloc>()..add(const LoadTailors()),
        child: const TailorListPage(),
      ),
    ),
    GoRoute(
      path: '/cities',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<CityBloc>()..add(const LoadCities()),
        child: const CityListPage(),
      ),
    ),
    GoRoute(
      path: '/order-groups',
      builder: (_, __) => BlocProvider(
        create: (_) => sl<OrderGroupBloc>()..add(const LoadOrderGroups()),
        child: const OrderGroupListPage(),
      ),
    ),
  ],
);
