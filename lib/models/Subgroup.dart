import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/product.dart';

class Subgroup {
  final int? id;
  final String name;
  final String description;
  final int groupId;
  final String code;
  List<Product>? products;

  Subgroup({
    this.id,
    required this.name,
    required this.description,
    required this.groupId,
    required this.code,
    this.products,
  });

  factory Subgroup.fromMap(Map<String, dynamic> map) {
    return Subgroup(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      groupId: map['group_id'],
      code: map['code'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'group_id': groupId,
      'code': code,
    };
  }

  Future<void> loadProducts(DatabaseHelper dbHelper) async {
    this.products = (await dbHelper.getProductsBySubgroupId(this.id!)).cast<Product>();
  }
}
