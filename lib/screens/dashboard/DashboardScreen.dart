import 'package:flutter/material.dart';
import 'package:minosapp/screens/customer/CustomerListScreen.dart';
import 'package:minosapp/screens/group/AddGroupScreen.dart';
import 'package:minosapp/screens/group/AddSubgroupScreen.dart';
import 'package:minosapp/screens/product/ProductListScreen.dart';
import 'package:minosapp/screens/supplier/SupplierListScreen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 242, 244),
              ),
              child: Image.asset(
                'assets/images/logo_minos.png',
                width: 50,
                height: 50,
              ),
            ),

            // Sección de usuario
            Container(
              color: Color.fromARGB(116, 123, 86, 136), // Fondo morado
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: const Row(
                children: [
                  // Imagen de perfil del usuario
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/images/user.png'), // Imagen de perfil
                  ),
                  SizedBox(width: 10),
                  // Nombre y rol del usuario
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrador',
                        style: TextStyle(
                          color: Color.fromARGB(255, 12, 12, 12),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Administrador',
                        style: TextStyle(
                          color: Color.fromARGB(179, 15, 15, 15),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            ListTile(
              leading: Image.asset(
                'assets/images/inicio.png',
                width: 30,
                height: 30,
              ),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
  leading: Image.asset(
    'assets/images/proveedores.png',
    width: 30,
    height: 30,
  ),
  title: const Text('Proveedores'),
  onTap: () {
    // Navega a la pantalla de la lista de proveedores
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SupplierListScreen()), // Redirige a SupplierListScreen
    );
  },
),
            ListTile(
              leading: Image.asset(
                'assets/images/productos.png',
                width: 30,
                height: 30,
              ),
              title: const Text('Productos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductListScreen()),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/clientes.png',
                width: 30,
                height: 30,
              ),
              title: const Text('Clientes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerListScreen()), // Aquí navega a la lista de clientes
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/ventas.png',
                width: 30,
                height: 30,
              ),
              title: const Text('Ventas'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/compras.png',
                width: 30,
                height: 30,
              ),
              title: const Text('Compras'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
     
            ExpansionTile(
              leading: Image.asset('assets/images/administracion.png', width: 30, height: 30),
              title: const Text('Administración'),
              children: <Widget>[
                // Tipos de comercio
                ListTile(
                  leading: Image.asset('assets/images/tipos_comercio.png', width: 30, height: 30),
                  title: const Text('Tipos de Comercio'),
                  onTap: () {
                    // Aquí puedes navegar a la pantalla correspondiente
                  },
                ),
                // Grupos
                ListTile(
                  leading: Image.asset('assets/images/grupos.png', width: 30, height: 30),
                  title: const Text('Grupos'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddGroupScreen()),
                    );
                  },
                ),
                // Subgrupos
                ListTile(
                  leading: Image.asset('assets/images/subgrupos.png', width: 30, height: 30),
                  title: const Text('Subgrupos'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddSubgroupScreen()),
                    );
                  },
                ),
                // Unidades
                ListTile(
                  leading: Image.asset('assets/images/unidades.png', width: 30, height: 30),
                  title: const Text('Unidades'),
                  onTap: () {
                    // Aquí puedes navegar a la pantalla correspondiente
                  },
                ),
                // Porcentajes de Impuesto
                ListTile(
                  leading: Image.asset('assets/images/porcentajes.png', width: 30, height: 30),
                  title: const Text('Porcentajes de Impuesto'),
                  onTap: () {
                    // Aquí puedes navegar a la pantalla correspondiente
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bienvenido al Dashboard',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Funcionalidad adicional
              },
              child: const Text('Ver Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
