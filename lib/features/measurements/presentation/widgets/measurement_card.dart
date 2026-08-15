import 'package:flutter/material.dart';

import '../../domain/entities/measurement.dart';

class MeasurementCard extends StatelessWidget {
  final Measurement measurement;

  const MeasurementCard({super.key, required this.measurement});

  String _cm(double? value) => value == null ? '-' : '${value.toStringAsFixed(1)} cm';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client #${measurement.customerId}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                Text('Poitrine: ${_cm(measurement.chest)}'),
                Text('Taille: ${_cm(measurement.waist)}'),
                Text('Epaules: ${_cm(measurement.shoulderWidth)}'),
                Text('Manche: ${_cm(measurement.sleeveLength)}'),
                Text('Pantalon: ${_cm(measurement.trouserLength)}'),
                Text('Cou: ${_cm(measurement.neckSize)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
