import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Color _statusColor() {
    switch (order.status) {
      case OrderStatus.livree:
        return Colors.green;
      case OrderStatus.annule:
        return Colors.red;
      case OrderStatus.pret:
      case OrderStatus.terminee:
        return Colors.blue;
      case OrderStatus.enCours:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text('Commande #${order.id.substring(0, 8)}'),
        subtitle: Text(
          '${Formatters.currency(order.totalPrice)} - Qte: ${order.quantity}',
        ),
        trailing: Chip(
          label: Text(order.status, style: const TextStyle(color: Colors.white)),
          backgroundColor: _statusColor(),
        ),
      ),
    );
  }
}
