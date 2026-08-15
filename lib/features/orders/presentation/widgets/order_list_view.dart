import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/order_bloc.dart';
import 'order_card.dart';

/// Contenu de la liste des commandes, sans Scaffold/AppBar -- reutilise a la
/// fois par [OrderListPage] (route directe) et par l'onglet Commandes de la
/// page d'accueil.
class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          context.showSnackBar(state.message, backgroundColor: Colors.red);
        }
        if (state is OrderOperationSuccess) {
          context.showSnackBar(state.message, backgroundColor: Colors.green);
        }
      },
      builder: (context, state) {
        if (state is OrderLoading || state is OrderInitial) {
          return const LoadingWidget();
        }
        if (state is OrderError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () => context.read<OrderBloc>().add(const RefreshOrders()),
          );
        }
        if (state is OrderLoaded) {
          if (state.orders.isEmpty) {
            return const EmptyStateWidget(message: 'Aucune commande trouvee');
          }
          return RefreshIndicator(
            onRefresh: () async => context.read<OrderBloc>().add(const RefreshOrders()),
            child: ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) => OrderCard(order: state.orders[index]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
