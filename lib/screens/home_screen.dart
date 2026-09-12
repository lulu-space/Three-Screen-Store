import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../routes/app_routes.dart';
import '../services/product_service.dart';
import '../widgets/category_strip.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const HomeScreen({super.key, required this.onLocaleChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Search ──────────────────────────────────────────────────────────────
  String _query = '';

  // ── Category selection (null = All) ─────────────────────────────────────
  int? _selectedCategoryId;

  // ── Categories state ────────────────────────────────────────────────────
  List<Category> _categories = [];
  bool _loadingCategories = false;
  String? _categoriesError;

  // ── Products state ──────────────────────────────────────────────────────
  List<Product> _products = [];
  bool _loadingProducts = false;
  String? _productsError;

  // ── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  // ── API calls ────────────────────────────────────────────────────────────

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
      _categoriesError = null;
    });
    try {
      final cats = await ProductService.fetchCategories();
      if (mounted) {
        setState(() {
          _categories = cats;
          _loadingCategories = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _categoriesError = 'Could not load categories';
          _loadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loadingProducts = true;
      _productsError = null;
    });
    try {
      final prods = _selectedCategoryId == null
          ? await ProductService.fetchProducts()
          : await ProductService.fetchProductsByCategory(_selectedCategoryId!);
      if (mounted) {
        setState(() {
          _products = prods;
          _loadingProducts = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _productsError = 'Could not load products';
          _loadingProducts = false;
        });
      }
    }
  }

  // ── Derived list filtered by live search ─────────────────────────────────
  List<Product> get _filtered {
    if (_query.isEmpty) return _products;
    final q = _query.toLowerCase();
    return _products.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  // ── UI ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        centerTitle: true,
        actions: [
          // Language switcher
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: widget.onLocaleChange,
            itemBuilder: (_) => const [
              PopupMenuItem(value: Locale('en'), child: Text('English')),
              PopupMenuItem(value: Locale('ar'), child: Text('العربية')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: t.searchProducts,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          const SizedBox(height: 8),

          // ── Category chips ──────────────────────────────────────────────
          if (_loadingCategories)
            const SizedBox(
              height: 48,
              child: Center(child: LinearProgressIndicator()),
            )
          else if (_categoriesError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    _categoriesError!,
                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                  TextButton(
                    onPressed: _loadCategories,
                    child: const Text('Retry', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            )
          else
            CategoryStrip(
              categories: _categories,
              selectedCategoryId: _selectedCategoryId,
              onCategorySelected: (id) {
                setState(() => _selectedCategoryId = id);
                _loadProducts();
              },
            ),

          const SizedBox(height: 4),

          // ── Products area ───────────────────────────────────────────────
          Expanded(child: _buildProducts(width)),
        ],
      ),
    );
  }

  Widget _buildProducts(double width) {
    // Loading
    if (_loadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
    if (_productsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _productsError!,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty
    final items = _filtered;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _query.isNotEmpty
                  ? 'No products match "$_query"'
                  : 'No products in this category',
              style: const TextStyle(color: Colors.grey, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Grid
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: width < 600 ? 2 : 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return ProductCard(
          product: product,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.details,
            arguments: product,
          ),
        );
      },
    );
  }
}
