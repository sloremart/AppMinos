import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/sale.dart';
import 'package:minosapp/models/user.dart';

class Customer {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String contact;
  final String document;
  final int userId;

  // Relación con ventas y usuario
  List<Sale>? sales;
  User? user;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.contact,
    required this.document,
    required this.userId,
    this.sales,
    this.user,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      contact: map['contact'],
      document: map['document'],
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'contact': contact,
      'document': document,
      'user_id': userId,
    };
  }

  Future<void> loadSales(DatabaseHelper dbHelper) async {
    this.sales = (await dbHelper.getSalesByCustomerId(this.id!)).cast<Sale>();
  }

  Future<void> loadUser(DatabaseHelper dbHelper) async {
    user = (await dbHelper.getUserById(this.userId)) as User?;
  }
}
