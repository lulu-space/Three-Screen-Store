import '../models/product.dart';

// The product name lives in the .arb files, not here.
// 'id' is the translation key used to look the name up.
final List<Map<String, dynamic>> rawProducts = [
  {
    'id': 'headphones',
    'price': 149.0,
    'image': 'https://picsum.photos/id/1/300',
    'isNew': true,
    'category': 'Audio',
  },
  {
    'id': 'smartWatch',
    'price': 320.0,
    'image': 'https://picsum.photos/id/2/300',
    'isNew': false,
    'category': 'Watches',
  },
  {
    'id': 'speaker',
    'price': 89.0,
    'image': 'https://picsum.photos/id/3/300',
    'isNew': true,
    'category': 'Audio',
  },
  {
    'id': 'mouse',
    'price': 59.0,
    'image': 'https://picsum.photos/id/4/300',
    'isNew': false,
    'category': 'Accessories',
  },
  {
    'id': 'keyboard',
    'price': 129.0,
    'image': 'https://picsum.photos/id/5/300',
    'isNew': true,
    'category': 'Accessories',
  },
  {
    'id': 'monitor',
    'price': 799.0,
    'image': 'https://picsum.photos/id/6/300',
    'isNew': false,
    'category': 'Screens',
  },
  {
    'id': 'earbuds',
    'price': 199.0,
    'image': 'https://picsum.photos/id/7/300',
    'isNew': true,
    'category': 'Audio',
  },
  {
    'id': 'tracker',
    'price': 149.0,
    'image': 'https://picsum.photos/id/8/300',
    'isNew': false,
    'category': 'Watches',
  },
];

// Convert raw maps into Product objects
final List<Product> products =
    rawProducts.map((p) => Product.fromMap(p)).toList();
