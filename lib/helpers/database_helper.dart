import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await _initDb();
    return _db;
  }

  // Inicializar la base de datos
  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "minosapp.db");


    // Abrir o crear la base de datos
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  // Crear tablas en la base de datos
  Future<void> _onCreate(Database db, int version) async {
    try {
      // Crear tabla de usuarios
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT
        )
      ''');

      // Crear tabla de clientes
      await db.execute('''
        CREATE TABLE customers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT,
          phone TEXT,
          address TEXT,
          contact TEXT,
          user_id INTEGER,
          document TEXT,
          FOREIGN KEY(user_id) REFERENCES users(id)
        )
      ''');

      // Crear tabla de proveedores
      await db.execute('''
        CREATE TABLE suppliers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          contact TEXT,
          phone TEXT,
          address TEXT,
          document TEXT,
          email TEXT,
          user_id INTEGER,
          FOREIGN KEY(user_id) REFERENCES users(id)
        )
      ''');

      // Crear tabla de categorías
      await db.execute('''
        CREATE TABLE categories (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT
        )
      ''');

      // Crear tabla de subgrupos
      await db.execute('''
        CREATE TABLE subgroups (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          group_id INTEGER,
          code TEXT,
          FOREIGN KEY(group_id) REFERENCES groups(id)
        )
      ''');

      // Crear tabla de productos
      await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          code TEXT,
          description TEXT,
          applies_iva INTEGER,
          vat_percentage_id INTEGER,
          unit_id INTEGER,
          category_id INTEGER,
          subgroup_id INTEGER,
          supplier_id INTEGER,
          FOREIGN KEY(vat_percentage_id) REFERENCES vat_percentages(id),
          FOREIGN KEY(unit_id) REFERENCES units(id),
          FOREIGN KEY(category_id) REFERENCES categories(id),
          FOREIGN KEY(subgroup_id) REFERENCES subgroups(id),
          FOREIGN KEY(supplier_id) REFERENCES suppliers(id)
        )
      ''');

      // Crear tabla de ventas
      await db.execute('''
        CREATE TABLE sales (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER,
          user_id INTEGER,
          sale_date TEXT,
          total_amount REAL,
          payment_method TEXT,
          FOREIGN KEY(customer_id) REFERENCES customers(id),
          FOREIGN KEY(user_id) REFERENCES users(id)
        )
      ''');

      // Crear tabla de detalles de venta
      await db.execute('''
        CREATE TABLE sale_details (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sale_id INTEGER,
          product_id INTEGER,
          quantity INTEGER,
          unit_price REAL,
          sub_total REAL,
          FOREIGN KEY(sale_id) REFERENCES sales(id),
          FOREIGN KEY(product_id) REFERENCES products(id)
        )
      ''');

      // Crear tabla de compras
      await db.execute('''
        CREATE TABLE purchases (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          supplier_id INTEGER,
          user_id INTEGER,
          purchase_date TEXT,
          total_amount REAL,
          FOREIGN KEY(supplier_id) REFERENCES suppliers(id),
          FOREIGN KEY(user_id) REFERENCES users(id)
        )
      ''');

      // Crear tabla de detalles de compra
      await db.execute('''
        CREATE TABLE purchase_details (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          purchase_id INTEGER,
          product_id INTEGER,
          quantity INTEGER,
          unit_price REAL,
          sub_total REAL,
          FOREIGN KEY(purchase_id) REFERENCES purchases(id),
          FOREIGN KEY(product_id) REFERENCES products(id)
        )
      ''');
        // Crear tabla de comercios
    await db.execute('''
      CREATE TABLE comercios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    // Insertar datos iniciales en la tabla de comercios
    await db.execute('''
      INSERT INTO comercios (name) VALUES
      ('Supermercado'),
      ('Farmacia'),
      ('Tienda de Ropa')
    ''');

      // Crear tabla de unidades
      await db.execute('''
        CREATE TABLE units (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          abbreviation TEXT
        )
      ''');

      // Crear tabla de porcentajes de IVA
      await db.execute('''
        CREATE TABLE vat_percentages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          percentage REAL,
          description TEXT
        )
      ''');

    } catch (e) {
      print("Error al crear la base de datos o insertar datos: $e");
    }
  }

  // Métodos CRUD y consultas

  // Usuarios
  Future<int> insertUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient!.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Productos
  Future<int> insertProduct(Map<String, dynamic> product) async {
    var dbClient = await db;
    return await dbClient!.insert('products', product);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    var dbClient = await db;
    return await dbClient!.query('products');
  }

  Future<Map<String, dynamic>?> getProductById(int id) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    var dbClient = await db;
    return await dbClient!.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [product['id']],
    );
  }

  Future<int> deleteProduct(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }




  Future<Map<String, dynamic>?> getSupplierById(int id) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'suppliers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

 


  // Ventas
  Future<int> insertSale(Map<String, dynamic> sale) async {
    var dbClient = await db;
    return await dbClient!.insert('sales', sale);
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    var dbClient = await db;
    return await dbClient!.query('sales');
  }

  Future<Map<String, dynamic>?> getSaleById(int id) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateSale(Map<String, dynamic> sale) async {
    var dbClient = await db;
    return await dbClient!.update(
      'sales',
      sale,
      where: 'id = ?',
      whereArgs: [sale['id']],
    );
  }

  Future<int> deleteSale(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Detalles de Venta
  Future<int> insertSaleDetail(Map<String, dynamic> saleDetail) async {
    var dbClient = await db;
    return await dbClient!.insert('sale_details', saleDetail);
  }

  Future<List<Map<String, dynamic>>> getSaleDetailsBySaleId(int saleId) async {
    var dbClient = await db;
    return await dbClient!.query(
      'sale_details',
      where: 'sale_id = ?',
      whereArgs: [saleId],
    );
  }

  Future<int> updateSaleDetail(Map<String, dynamic> saleDetail) async {
    var dbClient = await db;
    return await dbClient!.update(
      'sale_details',
      saleDetail,
      where: 'id = ?',
      whereArgs: [saleDetail['id']],
    );
  }

  Future<int> deleteSaleDetail(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'sale_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Compras
  Future<int> insertPurchase(Map<String, dynamic> purchase) async {
    var dbClient = await db;
    return await dbClient!.insert('purchases', purchase);
  }

  Future<List<Map<String, dynamic>>> getPurchases() async {
    var dbClient = await db;
    return await dbClient!.query('purchases');
  }

  Future<Map<String, dynamic>?> getPurchaseById(int id) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'purchases',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updatePurchase(Map<String, dynamic> purchase) async {
    var dbClient = await db;
    return await dbClient!.update(
      'purchases',
      purchase,
      where: 'id = ?',
      whereArgs: [purchase['id']],
    );
  }

  Future<int> deletePurchase(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'purchases',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Detalles de Compra
  Future<int> insertPurchaseDetail(Map<String, dynamic> purchaseDetail) async {
    var dbClient = await db;
    return await dbClient!.insert('purchase_details', purchaseDetail);
  }

  Future<List<Map<String, dynamic>>> getPurchaseDetailsByPurchaseId(int purchaseId) async {
    var dbClient = await db;
    return await dbClient!.query(
      'purchase_details',
      where: 'purchase_id = ?',
      whereArgs: [purchaseId],
    );
  }

  Future<int> updatePurchaseDetail(Map<String, dynamic> purchaseDetail) async {
    var dbClient = await db;
    return await dbClient!.update(
      'purchase_details',
      purchaseDetail,
      where: 'id = ?',
      whereArgs: [purchaseDetail['id']],
    );
  }

  Future<int> deletePurchaseDetail(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'purchase_details',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Obtener todos los comercios desde la base de datos
  Future<List<String>> getComercios() async {
    var dbClient = await db;
    var result = await dbClient!.query('comercios');
    return result.map((comercio) => comercio['name'].toString()).toList();
  }

  // Métodos adicionales (ventas por Customer ID, ventas por User ID, etc.)
  Future<Map<String, dynamic>?> getCustomerById(int id) async {
    var dbClient = await db;
    var result = await dbClient!.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getSalesByCustomerId(int customerId) async {
    var dbClient = await db;
    return await dbClient!.query(
      'sales',
      where: 'customer_id = ?',
      whereArgs: [customerId],
    );
  }

  Future<List<Map<String, dynamic>>> getSalesByUserId(int userId) async {
    var dbClient = await db;
    return await dbClient!.query(
      'sales',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getSuppliersByUserId(int userId) async {
    var dbClient = await db;
    return await dbClient!.query(
      'suppliers',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getProductsBySubgroupId(int subgroupId) async {
    var dbClient = await db;
    return await dbClient!.query(
      'products',
      where: 'subgroup_id = ?',
      whereArgs: [subgroupId],
    );
  }

  Future<List<Map<String, dynamic>>> getSubgroupsByGroupId(int groupId) async {
    var dbClient = await db;
    return await dbClient!.query(
      'subgroups',
      where: 'group_id = ?',
      whereArgs: [groupId],
    );
  }
// Insertar grupo
Future<int> insertGroup(Map<String, dynamic> group) async {
  var dbClient = await db;
  return await dbClient!.insert('groups', group);
}

// Obtener todos los grupos
Future<List<Map<String, dynamic>>> getGroups() async {
  var dbClient = await db;
  return await dbClient!.query('groups');
}

// Insertar subgrupo
Future<int> insertSubgroup(Map<String, dynamic> subgroup) async {
  var dbClient = await db;
  return await dbClient!.insert('subgroups', subgroup);
}

// Obtener todos los subgrupos
Future<List<Map<String, dynamic>>> getSubgroups() async {
  var dbClient = await db;
  return await dbClient!.query('subgroups');
}
Future<Map<String, dynamic>?> getCategoryById(int categoryId) async {
  var dbClient = await db;
  var result = await dbClient!.query(
    'categories',
    where: 'id = ?',
    whereArgs: [categoryId],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}
Future<Map<String, dynamic>?> getUnitById(int unitId) async {
  var dbClient = await db;
  var result = await dbClient!.query(
    'units',
    where: 'id = ?',
    whereArgs: [unitId],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}
Future<Map<String, dynamic>?> getVatPercentageById(int vatPercentageId) async {
  var dbClient = await db;
  var result = await dbClient!.query(
    'vat_percentages',
    where: 'id = ?',
    whereArgs: [vatPercentageId],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}
Future<Map<String, dynamic>?> getActivePriceForProduct(int productId) async {
  var dbClient = await db;
  var result = await dbClient!.query(
    'prices',
    where: 'product_id = ? AND active = 1',
    whereArgs: [productId],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}
Future<Map<String, dynamic>?> getInventoryByProductId(int productId) async {
  var dbClient = await db;
  var result = await dbClient!.query(
    'inventories',
    where: 'product_id = ?',
    whereArgs: [productId],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}
Future<Map<String, dynamic>?> getUser(String email, String password) async {
  var dbClient = await db;
  var result = await dbClient!.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}
Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  var dbClient = await db;
  var result = await dbClient!.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}

// customer 
Future<int> insertCustomer(Map<String, dynamic> customer) async {
  var dbClient = await db;
  return await dbClient!.insert('customers', customer);
}
// Obtener todos los clientes
Future<List<Map<String, dynamic>>> getCustomers() async {
  var dbClient = await db;
  return await dbClient!.query('customers');
}
// Eliminar cliente
Future<int> deleteCustomer(int id) async {
  var dbClient = await db;
  return await dbClient!.delete(
    'customers',
    where: 'id = ?',
    whereArgs: [id],
  );
}

// Editar cliente
Future<int> updateCustomer(Map<String, dynamic> customer) async {
  var dbClient = await db;
  return await dbClient!.update(
    'customers',
    customer,
    where: 'id = ?',
    whereArgs: [customer['id']], // El ID del cliente debe estar incluido en el mapa
  );
}

// Insertar proveedor
Future<int> insertSupplier(Map<String, dynamic> supplier) async {
  var dbClient = await db;
  return await dbClient!.insert('suppliers', supplier);
}

// Obtener todos los proveedores
Future<List<Map<String, dynamic>>> getSuppliers() async {
  var dbClient = await db;
  return await dbClient!.query('suppliers');
}

// Eliminar proveedor
Future<int> deleteSupplier(int id) async {
  var dbClient = await db;
  return await dbClient!.delete(
    'suppliers',
    where: 'id = ?',
    whereArgs: [id],
  );
}

// Editar proveedor
Future<int> updateSupplier(Map<String, dynamic> supplier) async {
  var dbClient = await db;
  return await dbClient!.update(
    'suppliers',
    supplier,
    where: 'id = ?',
    whereArgs: [supplier['id']],
  );
}


}