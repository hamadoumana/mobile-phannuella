import 'package:flutter/material.dart';

import '../../domain/entities/customer.dart';

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text('${customer.firstName} ${customer.lastName}'),
        subtitle: Text('${customer.phoneNumber} - ${customer.city}'),
      ),
    );
  }
}
