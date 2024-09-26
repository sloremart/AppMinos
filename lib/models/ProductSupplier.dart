class ProductSupplier {
  final int? productId;
  final int? supplierId;

  ProductSupplier({this.productId, this.supplierId});

  factory ProductSupplier.fromMap(Map<String, dynamic> map) {
    return ProductSupplier(
      productId: map['product_id'],
      supplierId: map['supplier_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'supplier_id': supplierId,
    };
  }
}
