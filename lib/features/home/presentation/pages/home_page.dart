import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../clothing_models/presentation/bloc/clothing_model_bloc.dart';
import '../../../clothing_models/presentation/widgets/clothing_model_list_view.dart';
import '../../../measurements/presentation/bloc/measurement_bloc.dart';
import '../../../measurements/presentation/pages/create_measurement_page.dart';
import '../../../measurements/presentation/widgets/measurement_list_view.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/pages/create_order_page.dart';
import '../../../orders/presentation/widgets/order_list_view.dart';
import '../../../../core/di/injection_container.dart';

const _tabTitles = ['Modeles disponibles', 'Mes mesures', 'Mes commandes'];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final ClothingModelBloc _clothingModelBloc =
      sl<ClothingModelBloc>()..add(const LoadClothingModels());
  late final MeasurementBloc _measurementBloc = sl<MeasurementBloc>()..add(const LoadMeasurements());
  late final OrderBloc _orderBloc = sl<OrderBloc>()..add(const LoadOrders());

  @override
  void dispose() {
    _clothingModelBloc.close();
    _measurementBloc.close();
    _orderBloc.close();
    super.dispose();
  }

  void _openCreateMeasurement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _measurementBloc,
          child: const CreateMeasurementPage(),
        ),
      ),
    );
  }

  void _openCreateOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _orderBloc,
          child: const CreateOrderPage(),
        ),
      ),
    );
  }

  Widget? _buildFab() {
    switch (_selectedIndex) {
      case 1:
        return FloatingActionButton(onPressed: _openCreateMeasurement, child: const Icon(Icons.add));
      case 2:
        return FloatingActionButton(onPressed: _openCreateOrder, child: const Icon(Icons.add));
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) context.go('/login');
      },
      child: Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text('Phannuella Couture', style: TextStyle(fontSize: 20)),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outline),
                        title: const Text('Mon compte'),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/account');
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.lightbulb_outline),
                        title: const Text('Nos Conseils'),
                        onTap: () => Navigator.pop(context),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.mail_outline),
                        title: const Text('Nous Contacter'),
                        onTap: () => Navigator.pop(context),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text('GESTION', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.people_outline),
                        title: const Text('Clients'),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/customers');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.texture),
                        title: const Text('Tissus'),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/fabrics');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.content_cut),
                        title: const Text('Couturiers'),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/tailors');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.location_city),
                        title: const Text('Villes'),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/cities');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.inventory_2_outlined),
                        title: const Text('Commandes groupees'),
                        onTap: () {
                          Navigator.pop(context);
                          context.go('/order-groups');
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.power_settings_new),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<AuthBloc>().add(const LogoutRequested());
                        },
                      ),
                      const SizedBox(width: 12),
                      const Text('Deconnexion', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(_tabTitles[_selectedIndex]),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.go('/notifications'),
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            BlocProvider.value(value: _clothingModelBloc, child: const ClothingModelListView()),
            BlocProvider.value(value: _measurementBloc, child: const MeasurementListView()),
            BlocProvider.value(value: _orderBloc, child: const OrderListView()),
          ],
        ),
        floatingActionButton: _buildFab(),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.checkroom), label: 'Accueil'),
            NavigationDestination(icon: Icon(Icons.straighten), label: 'Mesures'),
            NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'Commandes'),
          ],
        ),
      ),
    );
  }
}
