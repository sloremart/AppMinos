import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/screens/supplier/AddSupplierScreen.dart';

class SupplierListScreen extends StatefulWidget {
  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  List<Map<String, dynamic>> _suppliers = [];
  List<Map<String, dynamic>> _filteredSuppliers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  // Cargar la lista de proveedores desde la base de datos
  Future<void> _loadSuppliers() async {
    List<Map<String, dynamic>> suppliers = await DatabaseHelper().getSuppliers();
    setState(() {
      _suppliers = suppliers;
      _filteredSuppliers = suppliers; // Inicialmente, la lista filtrada es igual a la lista original
    });
  }

  // Filtrar proveedores por nombre
  void _filterSuppliers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredSuppliers = _suppliers.where((supplier) {
        final nameLower = supplier['name'].toLowerCase();
        return nameLower.contains(_searchQuery);
      }).toList();
    });
  }

  // Eliminar un proveedor de la base de datos
  Future<void> _deleteSupplier(int id) async {
    await DatabaseHelper().deleteSupplier(id); // Llamada para eliminar proveedor
    _loadSuppliers(); // Recargar la lista después de eliminar
  }

  // Redirigir a la pantalla de edición de proveedor
  void _editSupplier(Map<String, dynamic> supplier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSupplierScreen(supplier: supplier),
      ),
    ).then((_) {
      _loadSuppliers(); // Recargar la lista después de editar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proveedores'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                    ),
                    onChanged: _filterSuppliers, // Filtrar proveedores por nombre
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Crear Proveedor'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSupplierScreen()),
                      ).then((_) {
                        _loadSuppliers();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _filteredSuppliers.isEmpty
                ? Center(child: Text('No hay proveedores registrados.'))
                : ListView.builder(
                    itemCount: _filteredSuppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = _filteredSuppliers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          elevation: 5,
                          child: Stack(
                            children: [
                              // Logo dentro de la tarjeta (en el fondo)
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.1, // Baja opacidad
                                  child: Image.asset(
                                    'assets/images/proveedores.png', // Ruta del logo
                                    fit: BoxFit.cover, // Que el logo cubra el tamaño de la tarjeta
                                  ),
                                ),
                              ),
                              // Contenido de la tarjeta
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.business, color: const Color.fromARGB(255, 8, 57, 98)),
                                        SizedBox(width: 10),
                                        Text(
                                          supplier['name'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        // Popup menu para opciones de editar y eliminar
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'Editar') {
                                              _editSupplier(supplier); // Lógica para editar proveedor
                                            } else if (value == 'Eliminar') {
                                              _deleteSupplier(supplier['id']); // Lógica para eliminar proveedor
                                            }
                                          },
                                          itemBuilder: (BuildContext context) {
                                            return [
                                              const PopupMenuItem<String>(
                                                value: 'Editar',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.green),
                                                    SizedBox(width: 8),
                                                    Text('Editar'),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'Eliminar',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete,
                                                        color: Colors.red),
                                                    SizedBox(width: 8),
                                                    Text('Eliminar'),
                                                  ],
                                                ),
                                              ),
                                            ];
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    // Colocamos la información en dos columnas
                                    Row(
                                      children: [
                                        // Primera columna
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.email, color: const Color.fromARGB(255, 8, 57, 98)),
                                                  SizedBox(width: 10),
                                                  Text(supplier['email'] ?? 'N/A'),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.badge, color: const Color.fromARGB(255, 8, 57, 98)),
                                                  SizedBox(width: 10),
                                                  Text(supplier['document'] ?? 'N/A'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16), // Separador entre columnas
                                        // Segunda columna
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.phone, color: const Color.fromARGB(255, 8, 57, 98)),
                                                  SizedBox(width: 10),
                                                  Text(supplier['phone'] ?? 'N/A'),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on, color: const Color.fromARGB(255, 8, 57, 98)),
                                                  SizedBox(width: 10),
                                                  Text(supplier['address'] ?? 'N/A'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
