import 'package:flutter/material.dart';

/// Ouvre une feuille de bas d'ecran avec la liste des [items] a choisir.
/// Remplace `DropdownButtonFormField` pour les listes chargees depuis le
/// backend (plus fiable sur mobile qu'un menu deroulant natif pour une
/// liste de plusieurs elements).
Future<T?> showSelectSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) itemLabel,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                ),
                const Divider(height: 1),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('Aucun element disponible')),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: items.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(itemLabel(items[index])),
                        onTap: () => Navigator.of(context).pop(items[index]),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

/// Champ de formulaire type "picker" : affiche la valeur choisie et ouvre
/// [showSelectSheet] au tap. S'integre avec `Form`/`validator` comme un
/// `DropdownButtonFormField`.
class PickerFormField<T> extends FormField<T> {
  PickerFormField({
    super.key,
    required String label,
    required List<T> items,
    required String Function(T) itemLabel,
    super.initialValue,
    super.validator,
    ValueChanged<T?>? onChanged,
  }) : super(
          builder: (state) {
            return InkWell(
              onTap: () async {
                final selected = await showSelectSheet<T>(
                  context: state.context,
                  title: label,
                  items: items,
                  itemLabel: itemLabel,
                );
                if (selected != null) {
                  state.didChange(selected);
                  onChanged?.call(selected);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: label,
                  errorText: state.errorText,
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  state.value != null ? itemLabel(state.value as T) : '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
}
