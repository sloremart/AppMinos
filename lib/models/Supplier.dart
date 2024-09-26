// ignore: file_names
import 'package:minosapp/models/Product.dart';
import 'package:minosapp/models/Purchase.dart';
import 'package:minosapp/models/User.dart';

class Supplier {
  final int? id;
  final String name;
  final String contact;
  final String phone;
  final String address;
  final String document;
  final String email;
  final int userId;

  // Relación con productos, compras y usuario
  List<Product>? products;
  List<Purchase>? purchases;
  User? user;

  Supplier({
    this.id,
    required this.name,
    required this.contact,
    required this.phone,
    required this.address,
    required this.document,
    required this.email,
    required this.userId,
    this.products,
    this.purchases,
    this.user,
  });

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      phone: map['phone'],
      address: map['address'],
      document: map['document'],
      email: map['email'],
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'phone': phone,
      'address': address,
      'document': document,
      'email': email,
      'user_id': userId,
    };
  }



  
}
