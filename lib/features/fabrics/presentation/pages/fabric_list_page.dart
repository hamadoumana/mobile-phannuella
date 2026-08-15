import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/fabric_bloc.dart';
import '../widgets/fabric_card.dart';

class FabricListPage extends StatelessWidget {
  const FabricListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tissus')),
      body: BlocConsumer<FabricBloc, FabricState>(
        listener: (context, state) {
          if (state is FabricError) {
            context.showSnackBar(state.message, backgroundColor: Colors.red);
          }
          if (state is FabricOperationSuccess) {
            context.showSnackBar(state.message, backgroundColor: Colors.green);
          }
        },
        builder: (context, state) {
          if (state is FabricLoading || state is FabricInitial) {
            return const LoadingWidget();
          }
          if (state is FabricError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<FabricBloc>().add(const RefreshFabrics()),
            );
          }
          if (state is FabricLoaded) {
            if (state.fabrics.isEmpty) {
              return const EmptyStateWidget(message: 'Aucun tissu trouve');
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<FabricBloc>().add(const RefreshFabrics()),
              child: ListView.builder(
                itemCount: state.fabrics.length,
                itemBuilder: (context, index) => FabricCard(fabric: state.fabrics[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
