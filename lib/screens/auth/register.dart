import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';
import 'login.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _email, _password, _confirmPassword, _selectedComercio;
  String _errorMessage = '';
  List<String> _comercios = []; // Lista que se llenará dinámicamente con los comercios
  bool _isLoading = true; // Estado de carga

  @override
  void initState() {
    super.initState();
    _loadComercios(); // Cargar los comercios cuando el widget se inicialice
  }

  // Método para cargar los comercios desde la base de datos
Future<void> _loadComercios() async {
  try {
    List<String> comercios = await DatabaseHelper().getComercios();
    setState(() {
      _comercios = comercios;
      _isLoading = false; // Cambiar el estado de carga cuando los comercios se hayan cargado
    });
  } catch (e) {
    print('Error fetching comercios: $e'); // Imprimir el error si ocurre alguno
    setState(() => _isLoading = false);
  }
}

  // Método para registrar un nuevo usuario
  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Validar si la confirmación de la contraseña coincide
      if (_password != _confirmPassword) {
        setState(() {
          _errorMessage = 'Las contraseñas no coinciden';
        });
        return;
      }

      // Verificar si el correo ya está registrado
      var user = await DatabaseHelper().getUserByEmail(_email!);
      if (user != null) {
        setState(() {
          _errorMessage = 'El correo ya está registrado';
        });
        return;
      }

      // Insertar el nuevo usuario en la base de datos
      await DatabaseHelper().insertUser({
        'name': _name,
        'email': _email,
        'password': _password,
      });

      // Redirigir al usuario a la pantalla de inicio de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }  @override

  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mantener la imagen de fondo como papel tapiz
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/papel_tapiz.png'),
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
                            // Centrar más la imagen dentro del contenedor del formulario
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity: 0.1, // Mantener la opacidad baja para un fondo tenue
                                  child: Image.asset(
                                    'assets/images/icono_central.png',
                                    height: 250, // Ajustar el tamaño según sea necesario
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // Column para el formulario
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 24),
                                const Text(
                                  'REGISTRO',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  'SISTEMA MINOS',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),

                                // Formulario
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Campo Nombre
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Nombre Completo',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0), // Borde redondeado
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese su nombre';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _name = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Campo Correo
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Correo Electrónico',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0), // Borde redondeado
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingrese su correo electrónico';
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
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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

                                      // Campo Confirmar Contraseña
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Confirmar Contraseña',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0), // Borde redondeado
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, confirme su contraseña';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _confirmPassword = value;
                                        },
                                      ),
                                      const SizedBox(height: 16),

                                      // Mostrar Dropdown solo cuando los datos están cargados
                                      if (_isLoading)
                                        const CircularProgressIndicator(), // Mostrar cargando si aún no se ha cargado
                                      if (!_isLoading)
                                        DropdownButtonFormField<String>(
                                          value: _selectedComercio,
                                          decoration: InputDecoration(
                                            labelText: 'Tipo de Comercio',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(30.0), // Borde redondeado
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                          ),
                                          items: _comercios.map((comercio) {
                                            return DropdownMenuItem<String>(
                                              value: comercio,
                                              child: Text(comercio),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedComercio = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Por favor, seleccione un tipo de comercio';
                                            }
                                            return null;
                                          },
                                        ),
                                      const SizedBox(height: 16),

                                      // Botón de Registro
                                      ElevatedButton(
                                        onPressed: _register,
                                        child: const Text('Registrar'),
                                      ),
                                      const SizedBox(height: 16),

                                      // Error de mensaje
                                      if (_errorMessage.isNotEmpty)
                                        Text(
                                          _errorMessage,
                                          style: const TextStyle(color: Colors.red),
                                          textAlign: TextAlign.center,
                                        ),

                                      // Link para iniciar sesión
                                      const SizedBox(height: 16),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoginScreen()),
                                          );
                                        },
                                        child: const Text(
                                          '¿Ya estás registrado? Iniciar sesión',
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
