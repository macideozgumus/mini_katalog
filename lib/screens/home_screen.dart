import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> loadProducts() async {
    try {
      final String response = await rootBundle.loadString('assets/products.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
        filteredProducts = products;
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) =>
            product.name.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mini Katalog',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        toolbarHeight: 56,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search, size: 22, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      ),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text(
                'Ürün bulunamadı',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.70, // DEĞİŞTİ: 0.75'ten 0.70'e (hata gitti!)
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)
                            ),
                            child: Image.asset(
                              product.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported, 
                                      size: 40,
                                      color: Colors.grey
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 12, // DEĞİŞTİ: 13'ten 12'ye (alan kazandık)
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₺${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}