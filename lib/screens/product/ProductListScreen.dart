import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/product.dart';
import 'package:minosapp/screens/product/AddProductScreen.dart';
import 'package:minosapp/screens/product/ProductDetailScreen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    var dbHelper = DatabaseHelper();
    var productsData = await dbHelper.getProducts();
    List<Product> products = productsData.map((data) => Product.fromMap(data)).toList();

    // Cargar relaciones (categoría, proveedor, precio) para cada producto
    for (var product in products) {
      await product.loadRelations(dbHelper);
    }

    setState(() {
      _products = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              ).then((_) => _loadProducts());
            },
          ),
        ],
      ),
      body: _products.isEmpty
          ? Center(child: Text('No hay productos'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                var product = _products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Código: ${product.code}, Categoría: ${product.category?.name ?? ''}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    ).then((_) => _loadProducts());
                  },
                );
              },
            ),
    );
  }
}