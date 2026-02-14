class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  // JSON'dan Product oluşturan factory metodu
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  // Sabit örnek ürünler (istersen silebilirsin ama şimdilik kalsın)
  static List<Product> sampleProducts() {
    return [
      Product(id: 1, name: 'Akıllı Telefon', price: 8999.99, imageUrl: 'https://via.placeholder.com/150'),
      Product(id: 2, name: 'Laptop', price: 15499.50, imageUrl: 'https://via.placeholder.com/150'),
      Product(id: 3, name: 'Kulaklık', price: 1299.99, imageUrl: 'https://via.placeholder.com/150'),
      Product(id: 4, name: 'Akıllı Saat', price: 3499.90, imageUrl: 'https://via.placeholder.com/150'),
      Product(id: 5, name: 'Tablet', price: 6299.00, imageUrl: 'https://via.placeholder.com/150'),
    ];
  }
}