import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CityPickerScreen extends StatelessWidget {
  const CityPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    
    // Cities with their translation keys and values
    final cities = [
      {'key': 'ramallah', 'label': t.ramallah, 'value': 'Ramallah'},
      {'key': 'nablus', 'label': t.nablus, 'value': 'Nablus'},
      {'key': 'hebron', 'label': t.hebron, 'value': 'Hebron'},
      {'key': 'jerusalem', 'label': t.jerusalem, 'value': 'Jerusalem'},
      {'key': 'bethlehem', 'label': t.bethlehem, 'value': 'Bethlehem'},
      {'key': 'jenin', 'label': t.jenin, 'value': 'Jenin'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(t.chooseCity),
      ),
      body: ListView.separated(
        itemCount: cities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.location_city),
            ),
            title: Text(
              city['label']!,
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Return the city value back to the checkout screen
              Navigator.pop(context, city['label']);
            },
          );
        },
      ),
    );
  }
}
