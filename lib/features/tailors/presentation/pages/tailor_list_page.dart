import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/tailor_bloc.dart';
import '../widgets/tailor_card.dart';

class TailorListPage extends StatelessWidget {
  const TailorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Couturiers')),
      body: BlocConsumer<TailorBloc, TailorState>(
        listener: (context, state) {
          if (state is TailorError) {
            context.showSnackBar(state.message, backgroundColor: Colors.red);
          }
          if (state is TailorOperationSuccess) {
            context.showSnackBar(state.message, backgroundColor: Colors.green);
          }
        },
        builder: (context, state) {
          if (state is TailorLoading || state is TailorInitial) {
            return const LoadingWidget();
          }
          if (state is TailorError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<TailorBloc>().add(const RefreshTailors()),
            );
          }
          if (state is TailorLoaded) {
            if (state.tailors.isEmpty) {
              return const EmptyStateWidget(message: 'Aucun couturier trouve');
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<TailorBloc>().add(const RefreshTailors()),
              child: ListView.builder(
                itemCount: state.tailors.length,
                itemBuilder: (context, index) => TailorCard(tailor: state.tailors[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
