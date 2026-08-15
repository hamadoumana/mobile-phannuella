import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/order_group.dart';

class OrderGroupCard extends StatelessWidget {
  final OrderGroup orderGroup;

  const OrderGroupCard({super.key, required this.orderGroup});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(orderGroup.orderNumber),
        subtitle: Text(
          '${Formatters.currency(orderGroup.totalAmount)} - Solde: ${Formatters.currency(orderGroup.balance)}',
        ),
        trailing: Chip(label: Text(orderGroup.status)),
      ),
    );
  }
}
