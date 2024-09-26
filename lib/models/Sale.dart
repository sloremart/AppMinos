import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/customer.dart';
import 'package:minosapp/models/saledetail.dart';
import 'package:minosapp/models/user.dart';

class Sale {
  final int? id;
  final int customerId;
  final int userId;
  final String saleDate;
  final double totalAmount;
  final String paymentMethod;

  // Relación con detalles de venta, cliente y usuario
  List<SaleDetail>? saleDetails;
  Customer? customer;
  User? user;

  Sale({
    this.id,
    required this.customerId,
    required this.userId,
    required this.saleDate,
    required this.totalAmount,
    required this.paymentMethod,
    this.saleDetails,
    this.customer,
    this.user,
  });

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      customerId: map['customer_id'],
      userId: map['user_id'],
      saleDate: map['sale_date'],
      totalAmount: map['total_amount'],
      paymentMethod: map['payment_method'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'user_id': userId,
      'sale_date': saleDate,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
    };
  }

  Future<void> loadSaleDetails(DatabaseHelper dbHelper) async {
    this.saleDetails = (await dbHelper.getSaleDetailsBySaleId(this.id!)).cast<SaleDetail>();
  }

  Future<void> loadCustomer(DatabaseHelper dbHelper) async {
    this.customer = (await dbHelper.getCustomerById(this.customerId)) as Customer?;
  }

  Future<void> loadUser(DatabaseHelper dbHelper) async {
    this.user = (await dbHelper.getUserById(this.userId)) as User?;
  }
}