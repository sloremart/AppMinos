import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/PurchaseDetail.dart';
import 'package:minosapp/models/supplier.dart';
import 'package:minosapp/models/user.dart';

class Purchase {
  final int? id;
  final int supplierId;
  final int userId;
  final String purchaseDate;
  final double totalAmount;

  // Relación con detalles de compra, proveedor y usuario
  List<PurchaseDetail>? purchaseDetails;
  Supplier? supplier;
  User? user;

  Purchase({
    this.id,
    required this.supplierId,
    required this.userId,
    required this.purchaseDate,
    required this.totalAmount,
    this.purchaseDetails,
    this.supplier,
    this.user,
  });

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      supplierId: map['supplier_id'],
      userId: map['user_id'],
      purchaseDate: map['purchase_date'],
      totalAmount: map['total_amount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'supplier_id': supplierId,
      'user_id': userId,
      'purchase_date': purchaseDate,
      'total_amount': totalAmount,
    };
  }

  Future<void> loadPurchaseDetails(DatabaseHelper dbHelper) async {
    this.purchaseDetails = (await dbHelper.getPurchaseDetailsByPurchaseId(this.id!)).cast<PurchaseDetail>();
  }

  Future<void> loadSupplier(DatabaseHelper dbHelper) async {
    this.supplier = (await dbHelper.getSupplierById(this.supplierId)) as Supplier?;
  }

  Future<void> loadUser(DatabaseHelper dbHelper) async {
    this.user = (await dbHelper.getUserById(this.userId)) as User?;
  }
}
