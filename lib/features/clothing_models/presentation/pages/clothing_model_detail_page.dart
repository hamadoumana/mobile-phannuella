import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/formatters.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/pages/create_order_page.dart';
import '../../domain/entities/clothing_model.dart';

class ClothingModelDetailPage extends StatelessWidget {
  final ClothingModel clothingModel;

  const ClothingModelDetailPage({super.key, required this.clothingModel});

  void _openCommander(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<OrderBloc>(),
          child: CreateOrderPage(initialClothingModel: clothingModel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = clothingModel.photoUrl;
    return Scaffold(
      appBar: AppBar(title: Text(clothingModel.modelName)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: photoUrl == null
                ? Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const Icon(Icons.checkroom, size: 96),
                  )
                : CachedNetworkImage(
                    imageUrl: ApiConstants.resolveMediaUrl(photoUrl),
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: const Icon(Icons.broken_image_outlined, size: 96),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clothingModel.modelName, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 4),
                if (clothingModel.category != null)
                  Text(
                    clothingModel.category!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                const SizedBox(height: 12),
                Text(
                  Formatters.currency(clothingModel.unitPrice),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (clothingModel.description != null) ...[
                  const SizedBox(height: 16),
                  Text(clothingModel.description!),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => _openCommander(context),
                  child: const Text('Commander'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
