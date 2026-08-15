import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/clothing_model.dart';
import '../bloc/clothing_model_bloc.dart';
import 'clothing_model_card.dart';

/// Contenu de la liste des modeles disponibles, sans Scaffold/AppBar --
/// reutilise par [ClothingModelListPage] et par l'onglet Accueil. Inclut une
/// barre de recherche filtrant par nom (cote client, sur la liste chargee).
class ClothingModelListView extends StatefulWidget {
  const ClothingModelListView({super.key});

  @override
  State<ClothingModelListView> createState() => _ClothingModelListViewState();
}

class _ClothingModelListViewState extends State<ClothingModelListView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClothingModel> _filter(List<ClothingModel> models) {
    if (_query.trim().isEmpty) return models;
    final query = _query.trim().toLowerCase();
    return models.where((m) => m.modelName.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher un habit par nom...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: BlocConsumer<ClothingModelBloc, ClothingModelState>(
            listener: (context, state) {
              if (state is ClothingModelError) {
                context.showSnackBar(state.message, backgroundColor: Colors.red);
              }
            },
            builder: (context, state) {
              if (state is ClothingModelLoading || state is ClothingModelInitial) {
                return const LoadingWidget();
              }
              if (state is ClothingModelError) {
                return AppErrorWidget(
                  message: state.message,
                  onRetry: () =>
                      context.read<ClothingModelBloc>().add(const RefreshClothingModels()),
                );
              }
              if (state is ClothingModelLoaded) {
                final filtered = _filter(state.clothingModels);
                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    message: _query.isEmpty ? 'Aucun modele trouve' : 'Aucun resultat pour "$_query"',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<ClothingModelBloc>().add(const RefreshClothingModels()),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => ClothingModelCard(clothingModel: filtered[index]),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
