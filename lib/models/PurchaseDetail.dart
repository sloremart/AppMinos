import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/Purchase.dart';
import 'package:minosapp/models/product.dart';

class PurchaseDetail {
  final int? id;
  final int purchaseId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final double subTotal;

  // Relación con compra y producto
  Purchase? purchase;
  Product? product;

  PurchaseDetail({
    this.id,
    required this.purchaseId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
    this.purchase,
    this.product,
  });

  factory PurchaseDetail.fromMap(Map<String, dynamic> map) {
    return PurchaseDetail(
      id: map['id'],
      purchaseId: map['purchase_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      subTotal: map['sub_total'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchase_id': purchaseId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'sub_total': subTotal,
    };
  }

  Future<void> loadPurchase(DatabaseHelper dbHelper) async {
    this.purchase = (await dbHelper.getPurchaseById(this.purchaseId)) as Purchase?;
  }

  Future<void> loadProduct(DatabaseHelper dbHelper) async {
    this.product = (await dbHelper.getProductById(this.productId)) as Product?;
  }
}
