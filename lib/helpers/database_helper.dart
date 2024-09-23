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
      version: 1,
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

    
  } catch (e) {
    ("Error al crear la base de datos o insertar datprintos: $e");
  }
}

  // Insertar un usuario en la tabla users
  Future<int> insertUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient!.insert('users', user);
  }

  // Obtener un usuario por correo electrónico
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

  // Obtener un usuario por correo y contraseña
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

  // Eliminar un usuario (opcional)
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Actualizar un usuario (opcional)
  Future<int> updateUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient!.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // Obtener todos los comercios desde la base de datos
Future<List<String>> getComercios() async {
  try {
    var dbClient = await db;
    var result = await dbClient!.query('comercios');
   

    if (result.isEmpty) {

    }

    return result.map((comercio) => comercio['name'].toString()).toList();
  } catch (e) {
   
    return [];
  }
}
}