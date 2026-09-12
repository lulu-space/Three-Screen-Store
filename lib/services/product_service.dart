import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/category.dart';

class ProductService {
  static const String _base = 'https://store.bcite.org/public/api';
  static const Map<String, String> _headers = {'Accept': 'application/json'};

  /// GET /api/products — load all products
  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$_base/products'), headers: _headers);
    if (res.statusCode == 200) {
      final List raw = jsonDecode(res.body)['data'];
      return raw.map((j) => Product.fromJson(j)).toList();
    }
    throw Exception('Failed to load products (${res.statusCode})');
  }

  /// GET /api/categories — load all categories
  static Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse('$_base/categories'), headers: _headers);
    if (res.statusCode == 200) {
      final List raw = jsonDecode(res.body)['data'];
      return raw.map((j) => Category.fromJson(j)).toList();
    }
    throw Exception('Failed to load categories (${res.statusCode})');
  }

  /// GET /api/categories/{id}/products — load products for a category
  static Future<List<Product>> fetchProductsByCategory(int id) async {
    final res = await http.get(Uri.parse('$_base/categories/$id/products'), headers: _headers);
    if (res.statusCode == 200) {
      final List raw = jsonDecode(res.body)['data'];
      return raw.map((j) => Product.fromJson(j)).toList();
    }
    throw Exception('Failed to load products for category $id (${res.statusCode})');
  }
}
