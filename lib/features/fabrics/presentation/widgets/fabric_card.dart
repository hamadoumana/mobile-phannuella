import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/fabric.dart';

class FabricCard extends StatelessWidget {
  final Fabric fabric;

  const FabricCard({super.key, required this.fabric});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text('${fabric.fabricName}${fabric.color != null ? ' (${fabric.color})' : ''}'),
        subtitle: Text(
          '${Formatters.currency(fabric.pricePerMeter)}/m - Stock: ${fabric.quantityAvailable}',
        ),
      ),
    );
  }
}
