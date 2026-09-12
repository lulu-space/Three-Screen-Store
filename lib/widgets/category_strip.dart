import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryStrip extends StatelessWidget {
  /// Categories fetched from the API.
  final List<Category> categories;

  /// The currently selected category id, or null for "All".
  final int? selectedCategoryId;

  /// Called with the selected id, or null when "All" is tapped.
  final ValueChanged<int?> onCategorySelected;

  const CategoryStrip({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Prepend a virtual "All" entry; real categories follow.
    final total = categories.length + 1;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: total,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final id = isAll ? null : categories[index - 1].id;
          final label = isAll ? 'All' : categories[index - 1].name;
          final isSelected =
              isAll ? selectedCategoryId == null : selectedCategoryId == id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(id),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
