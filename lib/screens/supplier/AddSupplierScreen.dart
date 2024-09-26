import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';

class AddSupplierScreen extends StatefulWidget {
  final Map<String, dynamic>? supplier; // Proveedor opcional para editar

  const AddSupplierScreen({super.key, this.supplier});

  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  String? _contact;
  String? _document;
  bool isEditing = false; // Para diferenciar entre crear y editar

  @override
  void initState() {
    super.initState();

    // Si se está editando un proveedor, inicializa los valores del formulario
    if (widget.supplier != null) {
      isEditing = true;
      _name = widget.supplier!['name'];
      _email = widget.supplier!['email'];
      _phone = widget.supplier!['phone'];
      _address = widget.supplier!['address'];
      _contact = widget.supplier!['contact'];
      _document = widget.supplier!['document'];
    }
  }

  Future<void> _saveSupplier() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> supplier = {
        'name': _name,
        'email': _email,
        'phone': _phone,
        'address': _address,
        'contact': _contact,
        'document': _document,
      };

      if (isEditing) {
        // Si es edición, añade el id del proveedor al mapa
        supplier['id'] = widget.supplier!['id'];
        await DatabaseHelper().updateSupplier(supplier);
      } else {
        await DatabaseHelper().insertSupplier(supplier);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? 'Proveedor editado correctamente' : 'Proveedor agregado correctamente')),
      );

      Navigator.pop(context); // Volver atrás después de guardar
    }
  }

  void _cancel() {
    Navigator.pop(context); // Volver atrás sin guardar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo como papel tapiz
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/papel_tapiz.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.9),
                  BlendMode.modulate,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Imagen superior
              Image.asset(
                'assets/images/curva_arriba.png',
                width: MediaQuery.of(context).size.width,
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
                          color: Colors.white,
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
                                Text(
                                  isEditing ? 'EDITAR PROVEEDOR' : 'AGREGAR PROVEEDOR',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),

                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        initialValue: _name,
                                        decoration: InputDecoration(
                                          labelText: 'Nombre',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingresa el nombre';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => _name = value,
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        initialValue: _email,
                                        decoration: InputDecoration(
                                          labelText: 'Email',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Por favor, ingresa el email';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) => _email = value,
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        initialValue: _phone,
                                        decoration: InputDecoration(
                                          labelText: 'Teléfono',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        onSaved: (value) => _phone = value,
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        initialValue: _address,
                                        decoration: InputDecoration(
                                          labelText: 'Dirección',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        onSaved: (value) => _address = value,
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        initialValue: _document,
                                        decoration: InputDecoration(
                                          labelText: 'Documento',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                                        ),
                                        onSaved: (value) => _document = value,
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: _saveSupplier,
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                            ),
                                            child: const Text('Guardar'),
                                          ),
                                          OutlinedButton(
                                            onPressed: _cancel,
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                            ),
                                            child: const Text('Cancelar'),
                                          ),
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
                    ),
                  ),
                ),
              ),
              // Imagen inferior
              Image.asset(
                'assets/images/curva_abajo.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
