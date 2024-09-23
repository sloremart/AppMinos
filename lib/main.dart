import 'package:flutter/material.dart';
import 'package:minosapp/screens/auth/login.dart';
import 'package:minosapp/screens/auth/register.dart';
import 'package:minosapp/screens/dashboard/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();  // Inicializar plugins
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);  // Añadir const aquí

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minos App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => const RegisterScreen(),  // Añadir const aquí
        '/login': (context) => const LoginScreen(),  
        '/dashboard': (context) => const DashboardScreen(), 
      },
    );
  }
}