import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/order_group_bloc.dart';
import '../widgets/order_group_card.dart';

class OrderGroupListPage extends StatelessWidget {
  const OrderGroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Commandes groupees')),
      body: BlocConsumer<OrderGroupBloc, OrderGroupState>(
        listener: (context, state) {
          if (state is OrderGroupError) {
            context.showSnackBar(state.message, backgroundColor: Colors.red);
          }
          if (state is OrderGroupOperationSuccess) {
            context.showSnackBar(state.message, backgroundColor: Colors.green);
          }
        },
        builder: (context, state) {
          if (state is OrderGroupLoading || state is OrderGroupInitial) {
            return const LoadingWidget();
          }
          if (state is OrderGroupError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<OrderGroupBloc>().add(const RefreshOrderGroups()),
            );
          }
          if (state is OrderGroupLoaded) {
            if (state.orderGroups.isEmpty) {
              return const EmptyStateWidget(message: 'Aucune commande groupee trouvee');
            }
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<OrderGroupBloc>().add(const RefreshOrderGroups()),
              child: ListView.builder(
                itemCount: state.orderGroups.length,
                itemBuilder: (context, index) =>
                    OrderGroupCard(orderGroup: state.orderGroups[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
