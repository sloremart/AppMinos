import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/screens/customer/AddCustomerScreen.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  // Cargar la lista de clientes desde la base de datos
  Future<void> _loadCustomers() async {
    List<Map<String, dynamic>> customers = await DatabaseHelper().getCustomers();
    setState(() {
      _customers = customers;
      _filteredCustomers = customers; // Inicialmente, la lista filtrada es igual a la lista original
    });
  }

  // Filtrar clientes por nombre
  void _filterCustomers(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredCustomers = _customers.where((customer) {
        final nameLower = customer['name'].toLowerCase();
        return nameLower.contains(_searchQuery);
      }).toList();
    });
  }

  // Eliminar un cliente de la base de datos
  Future<void> _deleteCustomer(int id) async {
    await DatabaseHelper().deleteCustomer(id); // Llamada para eliminar cliente
    _loadCustomers(); // Recargar la lista después de eliminar
  }

// Redirigir a la pantalla de edición de cliente
void _editCustomer(Map<String, dynamic> customer) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AddCustomerScreen(customer: customer),
    ),
  ).then((_) {
    _loadCustomers(); // Recargar la lista después de editar
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
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
                    onChanged: _filterCustomers, // Filtrar clientes por nombre
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Crear Cliente'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCustomerScreen(customer: {},)),
                      ).then((_) {
                        _loadCustomers();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _filteredCustomers.isEmpty
                ? Center(child: Text('No hay clientes registrados.'))
                : ListView.builder(
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
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
                                    'assets/images/clientes.png', // Ruta del logo
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
                                        Icon(Icons.person, color: const Color.fromARGB(255, 8, 57, 98)),
                                        SizedBox(width: 10),
                                        Text(
                                          customer['name'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        // Popup menu para opciones de editar y eliminar
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'Editar') {
                                              _editCustomer(customer); // Lógica para editar cliente
                                            } else if (value == 'Eliminar') {
                                              _deleteCustomer(customer['id']); // Lógica para eliminar cliente
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
                                                  Icon(Icons.person, color: const Color.fromARGB(255, 8, 57, 98)),
                                                  SizedBox(width: 10),
                                                  Text(customer['name'] ?? 'N/A'),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.badge, color: const Color.fromARGB(255, 8, 57, 98)),
                                                  SizedBox(width: 10),
                                                  Text(customer['document'] ?? 'N/A'),
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
                                                  Text(customer['phone'] ?? 'N/A'),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on, color: const Color.fromARGB(255, 8, 57, 98)),
                                                  SizedBox(width: 10),
                                                  Text(customer['address'] ?? 'N/A'),
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
