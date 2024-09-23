import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';
import 'package:minosapp/screens/auth/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String _errorMessage = '';

  // Método para manejar el inicio de sesión
  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aquí puedes agregar la lógica para autenticar el usuario
      var user = await DatabaseHelper().getUser(_email!, _password!);
      if (user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        setState(() {
          _errorMessage = 'Correo o contraseña incorrectos';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mantener la imagen de fondo como papel tapiz
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/papel_tapiz.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.9), // Control de la opacidad
                  BlendMode.modulate,
                ),
              ),
            ),
          ),
          // Columna para posicionar las imágenes arriba, abajo y el formulario en el centro
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Imagen en la parte superior
              Image.asset(
                'assets/images/curva_arriba.png',  // Coloca aquí tu imagen superior
                width: MediaQuery.of(context).size.width,  // Ajustar al ancho de la pantalla
                fit: BoxFit.cover,
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fondo del formulario blanco puro
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity: 0.1,
                                  child: Image.asset(
                                    'assets/images/icono_central.png',
                                    height: 250,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 24),
                                const Text(
                                  'INICIAR SESIÓN',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  'BIENVENIDOS A NUESTRO SISTEMA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),

                                // Formulario de Login
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Correo Electrónico',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0), // Borde redondeado
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese su correo';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _email = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Campo Contraseña
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Contraseña',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0), // Borde redondeado
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese su contraseña';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _password = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      ElevatedButton(
                                        onPressed: _login,
                                        child: const Text('Iniciar Sesión'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0), // Borde redondeado
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Error de mensaje
                                      if (_errorMessage.isNotEmpty)
                                        Text(
                                          _errorMessage,
                                          style: const TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),
                                      
                                      const SizedBox(height: 16),

                                      // Link para redirigir a la pantalla de registro
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const RegisterScreen()),
                                          );
                                        },
                                        child: const Text(
                                          '¿No tienes cuenta? Regístrate aquí',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Imagen en la parte inferior
              Image.asset(
                'assets/images/curva_abajo.png',  // Coloca aquí tu imagen inferior
                width: MediaQuery.of(context).size.width,  // Ajustar al ancho de la pantalla
                fit: BoxFit.cover,
              ),
            ],
          ),
        ],
      ),
    );
  }
}