// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:minosapp/helpers/database_helper.dart';


class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _code = '';
  String _description = '';

  void _saveProduct() async {
    // Validar el formulario antes de guardar
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var dbHelper = DatabaseHelper();
      
      // Llama al método para insertar el producto en la base de datos
      int id = await dbHelper.insertProduct({
        'name': _name,
        'code': _code,
        'description': _description,
        'applies_iva': 1,  // Aquí puedes ajustar según sea necesario
        'vat_percentage_id': 1,  // Placeholder, ajusta según sea necesario
        'unit_id': 1,  // Placeholder
        'category_id': 1,  // Placeholder, ajusta según tus necesidades
        'subgroup_id': 1,  // Placeholder, ajusta según tus necesidades
      });

      if (id > 0) {
        // Si el producto se insertó correctamente, vuelve a la pantalla anterior
        Navigator.pop(context, true); // true indica que el producto fue creado
      } else {
        // Mostrar un mensaje de error si la inserción falló
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre del producto'),
                onSaved: (value) {
                  _name = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Código'),
                onSaved: (value) {
                  _code = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese un código';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onSaved: (value) {
                  _description = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
