import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/measurement_bloc.dart';
import 'measurement_card.dart';

/// Contenu de la liste des mesures, sans Scaffold/AppBar -- reutilise a la
/// fois par [MeasurementListPage] (route directe) et par l'onglet Mesures
/// de la page d'accueil.
class MeasurementListView extends StatelessWidget {
  const MeasurementListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MeasurementBloc, MeasurementState>(
      listener: (context, state) {
        if (state is MeasurementError) {
          context.showSnackBar(state.message, backgroundColor: Colors.red);
        }
        if (state is MeasurementOperationSuccess) {
          context.showSnackBar(state.message, backgroundColor: Colors.green);
        }
      },
      builder: (context, state) {
        if (state is MeasurementLoading || state is MeasurementInitial) {
          return const LoadingWidget();
        }
        if (state is MeasurementError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () => context.read<MeasurementBloc>().add(const RefreshMeasurements()),
          );
        }
        if (state is MeasurementLoaded) {
          if (state.measurements.isEmpty) {
            return const EmptyStateWidget(message: 'Aucune mesure trouvee');
          }
          return RefreshIndicator(
            onRefresh: () async => context.read<MeasurementBloc>().add(const RefreshMeasurements()),
            child: ListView.builder(
              itemCount: state.measurements.length,
              itemBuilder: (context, index) =>
                  MeasurementCard(measurement: state.measurements[index]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
