class Product {
  final String id;
  final double price;
  final String image;
  final bool isNew;
  final String category;

  const Product({
    required this.id,
    required this.price,
    required this.image,
    required this.isNew,
    required this.category,
  });

  // Factory constructor to convert from Map<String, dynamic>
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      price: map['price'],
      image: map['image'],
      isNew: map['isNew'],
      category: map['category'],
    );
  }
}
