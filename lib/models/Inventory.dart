class Inventory {
    final int? id;
    final int productId;
    final int userId;
    final int quantity;
    final String lastUpdatedDate;
  
    Inventory({
      this.id,
      required this.productId,
      required this.userId,
      required this.quantity,
      required this.lastUpdatedDate,
    });
  
    factory Inventory.fromMap(Map<String, dynamic> map) {
      return Inventory(
        id: map['id'],
        productId: map['product_id'],
        userId: map['user_id'],
        quantity: map['quantity'],
        lastUpdatedDate: map['last_updated_date'],
      );
    }
  
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'product_id': productId,
        'user_id': userId,
        'quantity': quantity,
        'last_updated_date': lastUpdatedDate,
      };
    }
  }
  