import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CategoryStrip extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryStrip({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    final categories = [
      {'key': 'All', 'label': t.all},
      {'key': 'Audio', 'label': t.audio},
      {'key': 'Watches', 'label': t.watches},
      {'key': 'Accessories', 'label': t.accessories},
      {'key': 'Screens', 'label': t.screens},
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['key'];
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category['label']!),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category['key']!),
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}
