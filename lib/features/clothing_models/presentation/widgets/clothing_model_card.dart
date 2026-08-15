import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/clothing_model.dart';
import '../pages/clothing_model_detail_page.dart';

/// Tuile de grille (2 colonnes sur la home page) : grande photo carree en
/// haut, nom et prix en dessous -- look catalogue/boutique.
class ClothingModelCard extends StatelessWidget {
  final ClothingModel clothingModel;

  const ClothingModelCard({super.key, required this.clothingModel});

  @override
  Widget build(BuildContext context) {
    final photoUrl = clothingModel.photoUrl;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClothingModelDetailPage(clothingModel: clothingModel),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: photoUrl == null
                  ? Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.checkroom, size: 48),
                    )
                  : CachedNetworkImage(
                      imageUrl: ApiConstants.resolveMediaUrl(photoUrl),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.broken_image_outlined, size: 48),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clothingModel.modelName,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.currency(clothingModel.unitPrice),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
