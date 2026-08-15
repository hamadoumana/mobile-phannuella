import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/city_bloc.dart';

class CityListPage extends StatelessWidget {
  const CityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Villes')),
      body: BlocBuilder<CityBloc, CityState>(
        builder: (context, state) {
          if (state is CityLoading || state is CityInitial) {
            return const LoadingWidget();
          }
          if (state is CityError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<CityBloc>().add(const RefreshCities()),
            );
          }
          if (state is CityLoaded) {
            if (state.cities.isEmpty) {
              return const EmptyStateWidget(message: 'Aucune ville trouvee');
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<CityBloc>().add(const RefreshCities()),
              child: ListView.builder(
                itemCount: state.cities.length,
                itemBuilder: (context, index) {
                  final city = state.cities[index];
                  return ListTile(
                    title: Text(city.name),
                    trailing: city.isActive
                        ? null
                        : const Text('Inactive', style: TextStyle(color: Colors.grey)),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
