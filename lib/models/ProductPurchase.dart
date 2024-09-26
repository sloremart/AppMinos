class ProductPurchase {
  final int? id;
  final int productId;
  final int purchaseId;
  final double purchasePrice;
  final String purchaseDate;

  ProductPurchase({
    this.id,
    required this.productId,
    required this.purchaseId,
    required this.purchasePrice,
    required this.purchaseDate,
  });

  factory ProductPurchase.fromMap(Map<String, dynamic> map) {
    return ProductPurchase(
      id: map['id'],
      productId: map['product_id'],
      purchaseId: map['purchase_id'],
      purchasePrice: map['purchase_price'],
      purchaseDate: map['purchase_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'purchase_id': purchaseId,
      'purchase_price': purchasePrice,
      'purchase_date': purchaseDate,
    };
  }
}
