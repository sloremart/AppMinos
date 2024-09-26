import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/models/Category.dart';
import 'package:minosapp/models/Supplier.dart';
import 'package:minosapp/models/Unit.dart';
import 'package:minosapp/models/VatPercentage.dart';
import 'package:minosapp/models/Price.dart';
import 'package:minosapp/models/Inventory.dart';

class Product {
  final int? id;
  final String name;
  final String code;
  final String description;
  final bool appliesIva;
  final int vatPercentageId;
  final int unitId;
  final int categoryId;
  final int subgroupId;

  // Relación con otras entidades
  Category? category;
  Supplier? supplier;
  Unit? unit;
  VatPercentage? vatPercentage;
  Price? activePrice;
  Inventory? inventory;

  Product({
    this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.appliesIva,
    required this.vatPercentageId,
    required this.unitId,
    required this.categoryId,
    required this.subgroupId,
    this.category,
    this.supplier,
    this.unit,
    this.vatPercentage,
    this.activePrice,
    this.inventory,
  });

  // Convertir de Map a objeto Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      description: map['description'],
      appliesIva: map['applies_iva'] == 1,
      vatPercentageId: map['vat_percentage_id'],
      unitId: map['unit_id'],
      categoryId: map['category_id'],
      subgroupId: map['subgroup_id'],
    );
  }

  // Convertir de objeto Product a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'applies_iva': appliesIva ? 1 : 0,
      'vat_percentage_id': vatPercentageId,
      'unit_id': unitId,
      'category_id': categoryId,
      'subgroup_id': subgroupId,
    };
  }

 // Cargar relaciones: categoría, proveedor, unidad, porcentaje de IVA, etc.
Future<void> loadRelations(DatabaseHelper dbHelper) async {
  category = (await dbHelper.getCategoryById(categoryId)) as Category?;
  supplier = (await dbHelper.getSupplierById(subgroupId)) as Supplier?;  // supplierId debe estar en el Product
  unit = (await dbHelper.getUnitById(unitId)) as Unit?;
  vatPercentage = (await dbHelper.getVatPercentageById(vatPercentageId)) as VatPercentage?;
  activePrice = (await dbHelper.getActivePriceForProduct(id!)) as Price?;
  inventory = (await dbHelper.getInventoryByProductId(id!)) as Inventory?;
}
}