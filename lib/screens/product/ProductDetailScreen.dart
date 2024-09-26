import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/product.dart';
import 'package:minosapp/screens/product/EditProductScreen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    var dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await dbHelper.deleteProduct(product.id!);
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: product),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nombre: ${product.name}', style: TextStyle(fontSize: 20)),
            Text('Código: ${product.code}', style: TextStyle(fontSize: 16)),
            Text('Descripción: ${product.description}', style: TextStyle(fontSize: 16)),
            Text('Categoría: ${product.category?.name ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            Text('Proveedor: ${product.supplier?.name ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            Text('Precio Activo: ${product.activePrice?.price ?? 0.0}', style: TextStyle(fontSize: 16)),
            Text('Cantidad en Inventario: ${product.inventory?.quantity ?? 0}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
