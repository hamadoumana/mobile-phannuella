import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/tailor.dart';

class TailorCard extends StatelessWidget {
  final Tailor tailor;

  const TailorCard({super.key, required this.tailor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: tailor.photoUrl != null
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  ApiConstants.resolveMediaUrl(tailor.photoUrl!),
                ),
              )
            : const CircleAvatar(child: Icon(Icons.content_cut)),
        title: Text(tailor.name),
        subtitle: Text('${tailor.workshopAddress} - ${tailor.city}'),
        trailing: Text(tailor.phoneNumber),
      ),
    );
  }
}
