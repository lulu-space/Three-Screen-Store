import 'package:flutter/material.dart';
import '../data/products.dart';
import '../l10n/app_localizations.dart';
import '../l10n/product_l10n.dart';
import '../models/product.dart';
import '../routes/app_routes.dart';
import '../widgets/category_strip.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const HomeScreen({
    super.key,
    required this.onLocaleChange,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Local copy so deletes are reflected in the UI
  late List<Product> _products;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _products = List.from(products);
  }

  List<Product> get _filtered {
    if (_selectedCategory == 'All') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  // ── Delete flow: AlertDialog → remove → SnackBar ──────────────────────────
  void _confirmDelete(BuildContext context, Product product) {
    final t = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.deleteProduct),
        content: Text(
          '${t.deleteConfirmMessage}\n\n"${t.productName(product.id)}"',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // cancel — closes dialog
            child: Text(t.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: Size.zero,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(context); // close dialog
              setState(() => _products.remove(product));
              // SnackBar confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.productDeleted),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: Text(t.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        actions: [
          // Language switcher
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: widget.onLocaleChange,
            itemBuilder: (context) => const [
              PopupMenuItem(value: Locale('en'), child: Text('English')),
              PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          CategoryStrip(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) =>
                setState(() => _selectedCategory = category),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: width < 600 ? 2 : 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final product = _filtered[index];
                return ProductCard(
                  product: product,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.details,
                    arguments: product,
                  ),
                  // Long-press triggers the delete dialog
                  onLongPress: () => _confirmDelete(context, product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
