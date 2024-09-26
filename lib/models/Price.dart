class Price {
  final int? id;
  final int productId;
  final int userId;
  final double price;
  final String validFromDate;
  final bool active;

  Price({
    this.id,
    required this.productId,
    required this.userId,
    required this.price,
    required this.validFromDate,
    required this.active,
  });

  factory Price.fromMap(Map<String, dynamic> map) {
    return Price(
      id: map['id'],
      productId: map['product_id'],
      userId: map['user_id'],
      price: map['price'],
      validFromDate: map['valid_from_date'],
      active: map['active'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'price': price,
      'valid_from_date': validFromDate,
      'active': active ? 1 : 0,
    };
  }
}
