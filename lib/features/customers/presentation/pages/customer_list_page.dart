import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/customer_bloc.dart';
import '../widgets/customer_card.dart';

class CustomerListPage extends StatelessWidget {
  const CustomerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerError) {
            context.showSnackBar(state.message, backgroundColor: Colors.red);
          }
          if (state is CustomerOperationSuccess) {
            context.showSnackBar(state.message, backgroundColor: Colors.green);
          }
        },
        builder: (context, state) {
          if (state is CustomerLoading || state is CustomerInitial) {
            return const LoadingWidget();
          }
          if (state is CustomerError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<CustomerBloc>().add(const RefreshCustomers()),
            );
          }
          if (state is CustomerLoaded) {
            if (state.customers.isEmpty) {
              return const EmptyStateWidget(message: 'Aucun client trouve');
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<CustomerBloc>().add(const RefreshCustomers()),
              child: ListView.builder(
                itemCount: state.customers.length,
                itemBuilder: (context, index) => CustomerCard(customer: state.customers[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
