import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/product.dart';
import 'package:minosapp/models/sale.dart';

class SaleDetail {
  final int? id;
  final int saleId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double subTotal;

  // Relación con venta y producto
  Sale? sale;
  Product? product;

  SaleDetail({
    this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
    this.sale,
    this.product,
  });

  factory SaleDetail.fromMap(Map<String, dynamic> map) {
    return SaleDetail(
      id: map['id'],
      saleId: map['sale_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      subTotal: map['sub_total'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sale_id': saleId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'sub_total': subTotal,
    };
  }

  Future<void> loadSale(DatabaseHelper dbHelper) async {
    this.sale = (await dbHelper.getSaleById(this.saleId)) as Sale?;
  }

  Future<void> loadProduct(DatabaseHelper dbHelper) async {
    this.product = (await dbHelper.getProductById(this.productId)) as Product?;
  }
}
