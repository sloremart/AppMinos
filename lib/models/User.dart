import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/sale.dart';
import 'package:minosapp/models/supplier.dart';

class User {
  final int? id;
  final String name;
  final String email;
  final String password;

  // Relación con las ventas y proveedores
  List<Sale>? sales;
  List<Supplier>? suppliers;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.sales,
    this.suppliers,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  Future<void> loadSales(DatabaseHelper dbHelper) async {
    this.sales = (await dbHelper.getSalesByUserId(this.id!)).cast<Sale>();
  }

  Future<void> loadSuppliers(DatabaseHelper dbHelper) async {
    this.suppliers = (await dbHelper.getSuppliersByUserId(this.id!)).cast<Supplier>();
  }
}